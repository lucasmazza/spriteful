require 'shellwords'
require 'thor/group'

module Spriteful
  class CLI < Thor::Group
    include Thor::Actions

    desc 'Generates image sprites with corresponding stylesheets.'

    argument :sources, type: :array, desc: 'Images to generate the sprites.', default: []

    class_option :format, aliases: '-f', banner: 'FORMAT', type: :string, desc: 'Format to generate the sprite(s) stylesheet(s). Either "css" or "scss".', default: 'css'
    class_option :stylesheets, aliases: '-s', banner: 'STYLESHEETS_DIR', type: :string, desc: 'Directory to save the generated stylesheet(s), instead of copying them to the clipboard.', default: Dir.pwd
    class_option :destination, aliases: '-d', banner: 'DESTINATION_DIR', type: :string, desc: 'Destination directory to save the combined image(s).', default: Dir.pwd
    class_option :name, aliases: '-n', banner: 'SPRITE_NAME', type: :string, desc: 'Name of generated sprite.'
    class_option :root, aliases: '-r', banner: 'ROOT_DIR', type: :string, desc: 'Root folder from where your static files will be served.'
    class_option :template, aliases: '-t', banner: 'TEMPLATE', type: :string, desc: 'Custom template file in ERB format to be used instead of the default.'

    class_option :mixin, type: :boolean, desc: 'Choose to use the Mixin Directives instead of Placeholder Selectors.'
    class_option :scale, type: :boolean, desc: 'Scale property changes the size of the image'
    class_option :rails, type: :boolean, desc: 'Follow default conventions for a Rails application with the Asset Pipeline.'
    class_option :horizontal, type: :boolean, desc: 'Change the sprite orientation to "horizontal".'
    class_option :save, type: :boolean, desc: 'Save the supplied arguments to ".spritefulrc".'
    class_option :spacing, type: :numeric, desc: 'Add spacing between the images in the sprite.'

    class_option :version, type: :boolean, aliases: '-v'
    class_option :optimize, type: :boolean, default: true, desc: 'Optimizes the combined PNG and inline SVG images.'

    class_option :force, type: :boolean, group: :runtime, desc: 'Always overwrite files that already exist.'

    # Public: Gets the CLI banner for the Thor help message.
    #
    # Returns a String.
    def self.banner
      'spriteful sources [options]'
    end

    # Public: Initializes the CLI object and replaces the frozen
    # 'options' object with an unfrozen one that we can mutate.
    def initialize(*)
      super
      self.options = options.dup
    end

    # Public: executes the CLI processing of the sprite sources
    # into combined images and stylesheets.
    # Returns nothing.
    def execute
      if options.version?
        say "Spriteful #{Spriteful::VERSION}"
        exit(0)
      end

      prepare_options!

      if sources.empty?
        self.class.help(shell)
        exit(1)
      end

      sources.uniq!
      sources.each do |source|
        create_sprite(source)
      end

      save_options
    end

    def template
      create_file "spriteful.#{options.format}", Spriteful::Stylesheet.read_template(options.format)
    end

    protected
    def self.dispatch(command, args, opts, config)
      if args.first == 'template'
        command = args.shift
      else
        command = 'execute'
      end
      super(command, args, opts, config)
    end

    private
    # Internal: Gets an instance of `Spriteful::Optimizer`.
    def optimizer
      @optimizer ||= Optimizer.new
    end

    # Internal: create a sprite image and stylesheet from a given source.
    #
    # Returns nothing.
    def create_sprite(source)
      sprite = Spriteful::Sprite.new(File.expand_path(source), options.destination, sprite_options)
      stylesheet = Spriteful::Stylesheet.new(sprite, File.expand_path(options.stylesheets), stylesheet_options)

      sprite.combine!
      if options.optimize?
        if optimizer.enabled?
          optimizer.optimize!(sprite.tmp_path)
        else
          say_status :optimizing, "No optimizer found. Please install at least one of the following: #{optimizer.optimizers.join(', ')}.", :yellow
        end
      end
      create_file sprite.path, sprite.blob
      create_file stylesheet.path, stylesheet.render
      sprite.cleanup
    end

    # Internal: Saves the existing options on 'ARGV' to the '.spritefulrc'
    # file if the '--save' flag is present.
    #
    # Returns nothing.
    def save_options
      if save_options?
        parts = Shellwords.join(@cli_options)
        create_file '.spritefulrc', parts + "\n", force: true
      end
    end

    def stylesheet_options
      template = File.expand_path(options.template) if File.file?(options.template.to_s)

      {
        root: options.root,
        format: options.format,
        rails: options.rails?,
        mixin: options.mixin?,
        scale: options.scale?,
        template: template,
        cli_options: @cli_options
      }
    end

    # Internal: Gets the set of options that are specific for the 'Sprite'
    # class.
    #
    # Returns a Hash.
    def sprite_options
      {
        horizontal: options.horizontal?,
        spacing: options.spacing,
        optimize: options.optimize,
        name: options.name
      }
    end

    # Internal: Changes the `options` hash if necessary (based on the
    # '--rails' flag) and store the original 'ARGV' array for further
    # usage.
    #
    # Returns nothing.
    def prepare_options!
      @cli_options = ARGV.dup.uniq
      @save_options = !!@cli_options.delete('--save')

      if options.rails?
        sources.concat(detect_sources)
        set_rails_defaults
      end
    end

    # Internal: Detects possible source directories in Rails applications
    # that are present inside the 'images/sprites' asset path.
    #
    # Returns an Array of directories.
    def detect_sources
      deprecated = Dir['app/assets/images/sprites/*'].select { |dir| File.directory?(dir) }

      if deprecated.any?
        deprecate "Deprecated sources found: #{deprecated.map { |path| "'#{path}'" }.join(', ')}.\nMove them to 'app/assets/sprites'."
      end

      deprecated + Dir['app/assets/sprites/*'].select { |dir| File.directory?(dir) }
    end

    # Internal: Sets Rails specific default options to the 'options' object.
    #
    # Returns nothing.
    def set_rails_defaults
      deprecated_stylesheets = 'app/assets/stylesheets/sprites'
      deprecated_destination = 'app/assets/images/sprites'

      if File.directory?(deprecated_destination) || File.directory?(deprecated_destination)
        deprecate "Sprites were previously saved at '#{deprecated_stylesheets}' and '#{deprecated_destination}'. They are now at 'app/assets/sprites' instead."
      end

      options['stylesheets'] = File.expand_path('app/assets/sprites')
      options['destination'] = File.expand_path('app/assets/sprites')
    end

    # Internal: Checks if we should save the supplied user arguments into
    # the rcfile.
    #
    # Returns true or false.
    def save_options?
      @save_options
    end

    def deprecate(message)
      say_status :deprecated, message, :red
    end
  end
end

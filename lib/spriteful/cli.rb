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
    class_option :root, aliases: '-r', banner: 'ROOT_DIR', type: :string, desc: 'Root folder from where your static files will be served.'

    class_option :mixin, type: :boolean, desc: 'Choose to use the Mixin Directives instead of Placeholder Selector'
    class_option :rails, type: :boolean, desc: 'Follow default conventions for a Rails application with the Asset Pipeline.'
    class_option :horizontal, type: :boolean, desc: 'Change the sprite orientation to "horizontal".'
    class_option :save, type: :boolean, desc: 'Save the supplied arguments to ".spritefulrc".'
    class_option :spacing, type: :numeric, desc: 'Add spacing between the images in the sprite.'

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

    private
    # Internal: create a sprite image and stylesheet from a given source.
    #
    # Returns nothing.
    def create_sprite(source)
      sprite = Spriteful::Sprite.new(File.expand_path(source), options.destination, sprite_options)
      stylesheet = Spriteful::Stylesheet.new(sprite, File.expand_path(options.stylesheets), stylesheet_options)

      sprite.combine!
      create_file sprite.path, sprite.blob
      create_file stylesheet.path, stylesheet.render
    end

    # Internal: Saves the existing options on 'ARGV' to the '.spritefulrc'
    # file if the '--save' flag is present.
    #
    # Returns nothing.
    def save_options
      if options.save?
        options.delete(:save)
        parts = sources + options.map { |key, value| ["--#{key}", value.to_s] }.flatten
        create_file '.spritefulrc', Shellwords.join(parts) + "\n", force: true
      end
    end

    def stylesheet_options
      {
        root: options.root,
        format: options.format,
        rails: options.rails?,
        mixin: options.mixin?
      }
    end

    # Internal: Gets the set of options that are specific for the 'Sprite'
    # class.
    #
    # Returns a Hash.
    def sprite_options
      {
        horizontal: options.horizontal?,
        spacing: options.spacing
      }
    end

    # Internal: Change the `options` hash if necessary, based on the
    # 'rails' flag.
    #
    # Returns nothing.
    def prepare_options!
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
      Dir['app/assets/images/sprites/*'].select { |dir| File.directory?(dir) }
    end

    # Internal: Sets Rails specific default options to the 'options' object.
    #
    # Returns nothing.
    def set_rails_defaults
      options['stylesheets'] = File.expand_path('app/assets/stylesheets/sprites')
      options['destination'] = File.expand_path('app/assets/images/sprites')
    end
  end
end

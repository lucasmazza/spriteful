require 'thor/group'

module Spriteful
  class CLI < ::Thor::Group
    include Thor::Actions
    desc 'Generates image sprites with corresponding stylesheets.'

    argument :sources, type: :array, desc: 'Images to generate the sprites.', default: []

    class_option :stylesheets, aliases: '-s', banner: 'STYLESHEETS_DIR', type: :string, desc: 'Directory to save the generated stylesheet(s), instead of copying them to the clipboard.', default: Dir.pwd
    class_option :format, aliases: '-f', banner: 'FORMAT', type: :string, desc: 'Format to generate the sprite(s) stylesheet(s). Either "css" or "scss".', default: 'css'
    class_option :destination, aliases: '-d', banner: 'DESTINATION_DIR', type: :string, desc: 'Destination directory to save the combined image(s).', default: Dir.pwd
    class_option :rails, aliases: '-r', type: :boolean, desc: 'Follow default conventions for a Rails application with the Asset Pipeline.'

    class_option :horizontal, type: :boolean, desc: 'Change the sprite orientation to "horizontal".'
    class_option :save, type: :boolean, desc: 'Save the supplied arguments to ".spritefulrc".'
    class_option :spacing, type: :numeric, desc: 'Add spacing between the images in the sprite.'

    def self.banner
      'spriteful sources [options]'
    end

    def initialize(*)
      super
      self.options = options.dup
    end

    def execute
      sprite_options = extract_sprite_options
      prepare_options!
      sources.each do |source|
        sprite = Spriteful::Sprite.new(File.expand_path(source), options['destination'], sprite_options)
        sprite.combine!
        create_file sprite.path, sprite.blob
        stylesheet = Spriteful::Stylesheet.new(sprite, File.expand_path(options['stylesheets']), options['format'], options['rails'])
        create_file stylesheet.path, stylesheet.render
      end

      if options['save']
        ARGV.delete('--save')
        create_file '.spritefulrc', ARGV.join(' ')
      end
    end

    private
    # Internal: Gets the set of options that are specific for the 'Sprite'
    # class.
    # Returns a Hash
    def extract_sprite_options
      sprite_options = { }
      sprite_options[:orientation] = (options.horizontal? ? :horizontal : :vertical)
      if options.spacing?
        sprite_options[:spacing] = options.spacing
      end
      sprite_options
    end

    # Internal: Change the `options` hash if necessary, based on the
    # 'rails' flag.
    #
    # Returns nothing.
    def prepare_options!
      if options.rails?
        sources.concat(detect_sources).uniq!
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

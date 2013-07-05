module Spriteful
  class CLI < ::Thor::Group
    include ::Thor::Actions
    include Spriteful::Thor::Actions
    desc 'Generates image sprites with corresponding stylesheets.'

    argument :sources, type: :array, desc: 'Images to generate the sprites.'

    class_option :stylesheets, aliases: '-s', banner: 'STYLESHEETS_DIR', type: :string, desc: 'Directory to save the generated stylesheet(s), instead of copying them to the clipboard.'
    class_option :format, aliases: '-f', banner: 'FORMAT', type: :string, desc: 'Format to generate the sprite(s) stylesheet(s). Either "css" or "scss".', default: 'css'
    class_option :destination, aliases: '-d', banner: 'DESTINATION_DIR', type: :string, desc: 'Destination directory to save the combined image(s).', default: Dir.pwd
    class_option :rails, aliases: '-r', type: :boolean, desc: 'Follow default conventions for a Rails application with the Asset Pipeline.'

    def self.banner
      'spriteful sources [options]'
    end

    def execute
      Spriteful.shell.wrap(self.shell)
      prepare_options!

      sources.each do |source|
        sprite = Spriteful::Sprite.new(File.expand_path(source), options['destination'])
        sprite.combine!
        create_file sprite.path, sprite.blob
        root = options['stylesheets'] || Dir.pwd
        stylesheet = Spriteful::Stylesheet.new(sprite, File.expand_path(root), options['format'])
        if options['stylesheets']
          stylesheet.write(File.expand_path(options['stylesheets']))
        else
          copy(stylesheet.name, stylesheet.render)
        end
      end
    end

    private
    # Internal: Change the `options` hash if necessary, based on the
    # 'rails' flag.
    #
    # Returns nothing.
    def prepare_options!
      if options.rails?
        sources.concat(detect_sources).uniq!
        set_rails_defaults
        options.delete('rails')
      end
    end

    # Internal: Detects possible source directories in Rails applications
    # that are present inside the 'images/sprites' asset path.
    #
    # Returns an Array of directories.
    def detect_sources
      Dir['app/assets/images/sprites/*'].select { |dir| File.directory?(dir) }
    end

    # Internal: Sets Rails specific default options to the 'options' Hash,
    # that is converted back to a plain Hash (instead of a 'HashWithIndifferentAccess')
    #
    # Returns nothing.
    def set_rails_defaults
      self.options = options.to_hash

      options['stylesheets'] ||= File.expand_path('app/assets/stylesheets/sprites')
      options['destination'] ||= File.expand_path('app/assets/images/sprites')
    end
  end
end

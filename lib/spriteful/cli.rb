require 'thor/group'

module Spriteful
  class CLI < Thor::Group
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
      if options.rails?
        sources.concat(detect_sources).uniq!
        prepare_options
        options.delete('rails')
      end
      puts [sources, options].flatten.inspect
    end

    private
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
    def prepare_options
      self.options = options.to_hash

      options['stylesheets'] ||= File.expand_path('app/assets/stylesheets')
      options['destination'] ||= File.expand_path('app/assets/images')
    end
  end
end

require 'thor/group'

module Spriteful
  class CLI < Thor::Group
    desc 'Generates image sprites with corresponding stylesheets using Compass spriting tools.'

    argument :sources, type: :array, required: true, desc: 'Image sources to generate the sprites.'

    class_option :css, banner: 'CSS_DIR', type: :string, desc: 'Directory to save the generated stylesheet(s), instead of copying them to the clipboard.'
    class_option :img, banner: 'IMAGES_DIR', type: :string, desc: 'Directory to save the generated image(s).', default: Dir.pwd
    class_option :rails, type: :boolean, desc: 'Follow default conventions for a Rails application with the Asset Pipeline.'
    class_option :template, banner: 'TEMPLATE_PATH', type: :string, desc: 'Alternative ERB/SCSS template file to use with Compass.'

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

      options['css'] ||= File.expand_path('app/assets/stylesheets')
      options['img'] ||= File.expand_path('app/assets/images')
    end
  end
end

require 'base64'

module Spriteful
  # Public: class responsible for putting together the CSS code
  # to use a specific sprite.
  class Stylesheet
    # Public: returns the format used to render the Stylesheet.
    attr_reader :format

    # Public: returns the 'Sprite' of this Stylesheet.
    attr_reader :sprite

    # Public: returns the path where the Stylesheet should be stored.
    attr_reader :path

    # Public: returns the custom template path.
    attr_reader :template_path

    # Public: Initialize a Stylesheet
    #
    # sprite        - a 'Sprite' object to create the Stylesheet.
    # destination   - the directory where the Stylesheet will be created.
    # options       - additional Hash of options.
    #                 :format - the Stylesheet format.
    #                 :mixin  - Use mixins instead of Placeholder selector in the SCSS format.
    #                 :rails  - A flag to generate Asset Pipeline compatible Stylesheets.
    def initialize(sprite, destination, options = {})
      @sprite = sprite
      @options = options
      @destination = destination

      @format = options[:format]
      @rails = !!options[:rails]
      @template_path = options[:template] || self.class.expand_template_path(@format)

      @path = File.join(@destination, name)
    end

    # Public: renders the CSS code for this Stylesheet.
    # An ERB template will be used to process the code, based
    # on the stylesheet format.
    #
    # Returns the CSS code as a 'String'.
    def render
      template = Template.new(@sprite, template_options)
      template.render(File.read(template_path))
    end

    # Public: returns this Stylesheet name, based
    # on the Sprite name and the current format.
    #
    # Returns a String.
    def name
      extension = rails? ? rails_extension : format
      "#{sprite_name}.#{extension}"
    end

    # Internal: Reads the default template Stylesheet for the given format.
    #
    # Returns a String.
    def self.read_template(format)
      path = expand_template_path(format)
      File.read(path)
    end

    # Internal: Expands the path to the default stylesheet for the given format.
    #
    # Returns the path as a String.
    def self.expand_template_path(format)
      File.expand_path("../stylesheets/template.#{format}.erb", __FILE__)
    end

    protected

    def template_options
      @options.merge(destination: @destination)
    end

    # Internal: returns the 'rails' flag.
    def rails?
      @rails
    end

    # Internal: defines the file extension to be used with
    # Rails applications, since we need to account for the ERB
    # preprocessing of plain CSS files.
    #
    # Returns a String.
    def rails_extension
      case format
      when 'css'
        'css.erb'
      when 'scss'
        'scss'
      end
    end

    def sprite_name
      case format
      when 'css'
        sprite.name
      when 'scss'
        "_#{sprite.name}"
      end
    end
  end
end

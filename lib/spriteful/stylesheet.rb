require 'erb'
require 'pathname'
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
      @destination = Pathname.new(destination)
      @root = nil
      if options[:root]
        @root = Pathname.new(File.expand_path(options[:root]))
      end
      @format = options[:format]
      @mixin = options.fetch(:mixin, false)
      @rails = options.fetch(:rails, false)
      @dimensions = options.fetch(:dimensions, false)

      @path = @destination.join(name)
    end

    # Public: renders the CSS code for this Stylesheet.
    # An ERB template will be used to process the code, based
    # on the stylesheet format.
    #
    # Returns the CSS code as a 'String'.
    def render
      source = File.expand_path("../stylesheets/template.#{format}.erb", __FILE__)
      ERB.new(File.read(source), nil, '-').result(binding)
    end

    # Public: returns this Stylesheet name, based
    # on the Sprite name and the current format.
    #
    # Returns a String.
    def name
      extension = rails? ? rails_extension : format
      "#{sprite_name}.#{extension}"
    end

    protected

    # Internal: returns the 'rails' flag.
    def rails?
      @rails
    end

    # Internal: returns the 'mixin' flag.
    def mixin?
      @mixin
    end

    # Internal: returns the 'dimensions' flag.
    def dimensions?
      @dimensions
    end

    # Internal: select the extension prefix for the SCSS selector.
    def extension_prefix
      mixin? ? '@mixin ' : '%'
    end

    # Internal: select the extension strategy for the SCSS selector.
    def extension_strategy
      mixin? ? '@include ' : '@extend %'
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

    # Internal: sanitizes the 'name' of a given object to
    # be used as a CSS selector class.
    #
    # Returns a 'String'.
    def class_name_for(object)
      object.name.split('.').first.downcase.tr('_', '-')
    end

    # Internal: computes a relative path between the sprite
    # path and the stylesheet expected location.
    #
    # Returns a 'String'.
    def image_url(sprite)
      path = Pathname.new(sprite.path)
      if @rails
        "sprites/#{sprite.filename}"
      elsif @root
        "/#{path.relative_path_from(@root)}"
      else
        path.relative_path_from(@destination)
      end
    end

    # Internal: Gets an embeddable Data URI of the image if it
    # is a SVG image.
    #
    # Returns a String.
    def data_uri(image)
      if image.svg?
        %['data:image/svg+xml;base64,#{Base64.encode64(image.blob).gsub(/\r?\n/, '')}']
      end
    end
  end
end

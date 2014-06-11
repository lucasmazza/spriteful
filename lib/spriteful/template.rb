require 'erb'
require 'pathname'

module Spriteful
  # Public: The Template class is the public API available in the ERB templates
  # that will render a CSS/SCSS stylesheet for a sprite.
  class Template
    # Public: Gets the sprite object that is being rendered with this template.
    attr_reader :sprite

    # Public: Initializes a Template object.
    #
    # sprite  - A instance of the Spriteful::Sprite object associated to this
    #           template.
    # options - The Hash options that configure this template (default: {}):
    #           :mixin - A flag marking if the template should generate SCSS
    #                    mixins instead of placeholders.
    #           :rails - A flag marking if the template is being generated in a
    #                    Rails app.
    #           :root  - Root folder from where the generate stylesheets will be
    #                    served.
    #           :destination - Folder where styleshee will live.
    def initialize(sprite, options = {})
      @sprite = sprite
      @options = options
      @destination = Pathname.new(options[:destination])

      if @options[:root]
        @root = Pathname.new(File.expand_path(options[:root]))
      else
        @root = nil
      end
    end

    # Public: sanitizes the 'name' of a given object to be used as a CSS selector
    # class.
    #
    # object - A Spriteful::Sprite or Spriteful::Image instance.
    #
    # Returns a String.
    def class_name_for(object)
      object.name.split('.').first.downcase.tr('_', '-')
    end

    # Public: Gets the extension prefix for the SCSS selector, based on the
    # ':mixin' option.
    #
    # Returns a String.
    def extension_prefix
      mixin? ? '@mixin ' : '%'
    end

    # Internal: Gets the extension strategy for the SCSS selector, based on the
    # ':mixin' option.
    #
    # Returns a String.
    def extension_strategy
      mixin? ? '@include ' : '@extend %'
    end

    # Public: Gets the ':mixin' flag.
    def mixin?
      !!@options[:mixin]
    end

    # Public: Gets the ':rails' flag.
    def rails?
      !!@options[:rails]
    end

    # Public: computes a relative path between the sprite path and the stylesheet
    # expected location.
    #
    # sprite - A Spriteful::Sprite instance.
    #
    # Returns a String.
    def image_url(sprite)
      path = Pathname.new(sprite.path)
      if rails?
        "sprites/#{sprite.filename}"
      elsif @root
        "/#{path.relative_path_from(@root)}"
      else
        path.relative_path_from(@destination).to_s
      end
    end

    # Public: Gets an embeddable Data URI of the image if it is a SVG image.
    #
    # image - A Spriteful::Image instance.
    #
    # Returns a String.
    def data_uri(image)
      if image.svg?
        "data:image/svg+xml;base64,#{Base64.encode64(image.blob).gsub(/\r?\n/, '')}"
      end
    end

    # Public: Renders the given source ERB template string in the context of the
    # template object.
    #
    # source - A String containing the ERB template.
    #
    # Returns a String.
    def render(source)
      ERB.new(source, nil, '-').result(binding)
    end
  end
end

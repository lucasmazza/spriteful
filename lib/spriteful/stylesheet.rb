require 'erb'

module Spriteful
  # Public: class responsible for putting together the CSS code
  # to use a specific sprite.
  class Stylesheet
    # Public: returns the format used to render the Stylesheet.
    attr_reader :format

    # Public: returns the 'Sprite' of this Stylesheet.
    attr_reader :sprite

    # Public: Initialize a Stylesheet
    #
    # sprite - a 'Sprite' object to create the Stylesheet.
    # root   - a root path of where the Stylesheet will be created.
    # format - the format for the CSS code.
    def initialize(sprite, root, format)
      @sprite = sprite
      @root = Pathname.new(root)
      @format = format
      @sprite_position = 0
    end

    # Public: renders the CSS code for this Stylesheet.
    # An ERB template will be used to process the code, based
    # on the stylesheet format.
    #
    # Returns the CSS code as a 'String'.
    def render
      source = File.expand_path("../stylesheets/template.#{format}.erb", __FILE__)
      ERB.new(File.read(source)).result(binding)
    end

    # Public: stores the stylesheet in a destination directory,
    # using the sprite name and the stylesheet format for the
    # stylesheet file name.
    #
    # Returns nothing.
    def write(destination)
      path = File.join(destination, "#{sprite.name}.#{format}")
      File.open(path, 'w') { |io| io.write(render) }
    end

    protected

    # Internal: computes the vertical position of a image from
    # the sprite, accumulating the image heights on every
    # iteration.
    #
    # Returns the position as a 'Fixnum'.
    def position_for(image)
      current_position = @sprite_position
      @sprite_position -= image.height
      current_position
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
      Pathname.new(sprite.path).relative_path_from(@root)
    end
  end
end

require 'pathname'
require 'erb'

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
    # sprite - a 'Sprite' object to create the Stylesheet.
    # root   - a root path of where the Stylesheet will be created.
    # format - the format for the CSS code.
    def initialize(sprite, root, format, rails = false)
      @sprite = sprite
      @root = Pathname.new(root)
      @format = format
      @rails = rails

      @path = @root.join(name)
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
      "#{sprite.name}.#{extension}"
    end

    protected

    # Internal: returns the 'rails ' flag.
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
      if @rails
        "sprites/#{sprite.filename}"
      else
        Pathname.new(sprite.path).relative_path_from(@root)
      end
    end
  end
end

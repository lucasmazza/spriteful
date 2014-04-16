require 'svg_optimizer'

module Spriteful
  # Internal: Data structure to represent the images that are part
  # of a sprite.
  class Image
    # Public: returns the path where the Image lives.
    attr_reader :path

    # Public: returns the filename of the Image.
    attr_reader :name

    # Public: returns the Image width in pixels.
    attr_reader :width

    # Public: returns the Image height in pixels.
    attr_reader :height

    # Public: Gets/sets the top position of the image in a sprite.
    attr_accessor :top

    # Public: Gets/sets the left position of the image in a sprite.
    attr_accessor :left

    # Public: Gets the source 'Magick::Image'.
    attr_reader :source

    # Public: Initializes an Image, extracting the image
    # metadata such as width and path supplied by an 'Magick::Image'
    # object that was initialized from the real image blob.
    #
    # magick_image - an 'Magick::Image' object.
    def initialize(magick_image, optimize=true)
      @source = magick_image
      @path   = magick_image.base_filename
      @name   = File.basename(@path)
      @width  = magick_image.columns
      @height = magick_image.rows
      @optimize = optimize

      @top    = 0
      @left   = 0
    end

    # Public: Gets the source image contents.
    #
    # Returns a String.
    def blob
      @blob ||= read_blob
    end

    # Public: detects if the source is a SVG image
    # based on its path.
    #
    # Returns true or false.
    def svg?
      File.extname(@path) == '.svg'
    end

    private

    def read_blob
      contents = File.read(path)
      if @optimize
        SvgOptimizer.optimize(contents)
      else
        contents
      end
    end
  end
end

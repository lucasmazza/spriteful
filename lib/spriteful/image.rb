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

    # Public: Gets the source 'ChunkyPNG::Image'.
    attr_reader :source

    # Public: Initializes an Image, extracting the image
    # metadata such as width and path supplied by an 'ChunkyPNG::Image'
    # object that was initialized from the real image blob.
    #
    # chunky_image - an 'ChunkyPNG::Image' object.
    # path         - the path where the image is present.
    def initialize(chunky_image, path)
      @source = chunky_image
      @path   = path
      @name   = File.basename(@path)
      @width  = chunky_image.width
      @height = chunky_image.height

      @top    = 0
      @left   = 0
    end
  end
end

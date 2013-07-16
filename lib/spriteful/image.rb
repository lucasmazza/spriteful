module Spriteful
  # Internal: Data structure to represent the images that are part
  # of a sprite.
  class Image
    attr_accessor :name, :path, :width, :height, :top, :left
    # Public: Initializes an Image.
    #
    # magick_image - an 'RMagick::Image' instance.
    def initialize(magick_image)
      @path   = magick_image.filename
      @name   = File.basename(@path)
      @width  = magick_image.columns
      @height = magick_image.rows
      @top    = 0
      @left   = 0
    end
  end
end

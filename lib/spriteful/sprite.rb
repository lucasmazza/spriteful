require 'RMagick'

module Spriteful
  # Public: the 'Sprite' class is responsible for combining a directory
  # of images into a single one, and providing the required information
  # about the related images.
  class Sprite
    # Public: returns the path where the sprite will be saved.
    attr_reader :path

    # Public: returns name of the sprite.
    attr_reader :name

    # Public: returns filename of the sprite.
    attr_reader :filename

    # Public: returns the binary contents of the combined image.
    attr_reader :blob

    # Public: Initialize a Sprite.
    #
    # source_dir - the source directory where the sprite images are located.
    # destination - the destination directory where the sprite should be saved.
    def initialize(source_dir, destination)
      source_pattern = File.join(source_dir, '*.png')
      sources = Dir[source_pattern].sort

      if sources.size == 0
        raise EmptySourceError, "No image sources found at '#{source_dir}'."
      end

      @name     = File.basename(source_dir)
      @filename = "#{name}.png"
      @path     = File.join(destination, @filename)
      @list     = Magick::ImageList.new(*sources)
      @images   = initialize_images(@list)
    end

    # Public: combines the source images into a single one,
    # storing the combined image into the sprite path.
    #
    # Returns nothing.
    def combine!
      @list.each { |image| image.background_color = 'none' }
      combined = @list.append(true)
      @blob = combined.to_blob
    end

    # Public: exposes the source images found in the 'source'
    # directory.
    #
    # Yields an 'Image' object on each interation.
    #
    # Returns an 'Enumerator' if no block is given.
    def each_image
      return to_enum(__method__) unless block_given?
      @images.each { |image| yield image }
    end

    alias :images :each_image

    protected
    # Internal: Initializes a collection of 'Image' objects
    # based on the 'source' images. The images will have
    # the source images metadata and the required 'top' and
    # 'left' coordinates that the image will be placed
    # in the sprite.
    #
    # list - a 'RMagick::ImageList' of sources.
    # Returns an Array
    def initialize_images(list)
      sprite_position = 0

      list.to_a.map do |magick_image|
        image = Image.new(magick_image)

        image.top = sprite_position
        sprite_position -= image.height

        image
      end
    end
  end
end

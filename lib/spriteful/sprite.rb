require 'RMagick'

module Spriteful
  # Public: the 'Sprite' class is responsible for combining a directory
  # of images into a single one, and providing the required information
  # about the related images.
  class Sprite
    # Internal: Data structure to represent the images found in the 'source'
    # directory.
    Image = Struct.new(:name, :path, :width, :height)

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
      @list.each do |image|
        yield create_image(image)
      end
    end

    alias :images :each_image

    protected
    # Internal: wraps a given 'Magick::Image' object into a plain
    # 'Image' instance, a simple 'Struct' that abstracts the RMagick
    # API for dealing with image details like height and width.
    #
    # Returns an 'Image' instance.
    def create_image(magick_image)
      name = File.basename(magick_image.filename)
      Image.new(name, magick_image.filename, magick_image.columns, magick_image.rows)
    end
  end
end

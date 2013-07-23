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

    # Public: returns the spacing between the images in the sprite.
    attr_reader :spacing

    # Public: returns the binary contents of the combined image.
    attr_reader :blob

    # Public: returns the width of the combined image.
    attr_reader :width

    # Public: returns the height of the combined image.
    attr_reader :height

    # Public: Initialize a Sprite.
    #
    # source_dir  - the source directory where the sprite images are located.
    # destination - the destination directory where the sprite should be saved.
    # options     - additional Hash of options.
    #               :orientation - orientation of the sprite, either ':vertical'
    #                              or ':horizontal'.
    #               :spacing - spacing in pixels that should be placed between
    #                          the images in the sprite. Defaults to 0.
    def initialize(source_dir, destination, options = {})
      source_pattern = File.join(source_dir, '*.png')
      sources = Dir[source_pattern].sort

      if sources.size == 0
        raise EmptySourceError, "No image sources found at '#{source_dir}'."
      end

      @orientation = options.fetch(:orientation, :vertical)
      @spacing     = options.fetch(:spacing, 0)

      @name     = File.basename(source_dir)
      @filename = "#{name}.png"
      @path     = File.join(destination, @filename)
      @list     = Magick::ImageList.new(*sources)
      @images   = initialize_images(@list)

      @height, @width = detect_dimensions
    end

    # Public: combines the source images into a single one,
    # storing the combined image into the sprite path.
    #
    # Returns nothing.
    def combine!
      combined = Magick::Image.new(width, height)
      combined.opacity = Magick::MaxRGB
      @images.each do |image|
        combined.composite!(image.source, image.left.abs, image.top.abs, Magick::SrcOverCompositeOp)
      end
      @blob = combined.to_blob { self.format = 'png' }
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
    # Internal: detect the expected 'height' and 'width' of the
    # combined image of this sprite. This should take in account
    # the sprite orientation and the configured spacing.
    #
    # Returns an Array with the 'height' and 'width'.
    def detect_dimensions
      total_spacing = (@images.size - 1) * spacing

      if vertical_sprite?
        height   = @images.map { |image| image.height }.inject(:+) + total_spacing
        width    = @images.map { |image| image.width }.max
      else
        height  = @images.map { |image| image.height }.max
        width   = @images.map { |image| image.width }.inject(:+) + total_spacing
      end

      [height, width]
    end

    # Internal: Checks if the sprite should be combined vertically.
    #
    # Returns true or false.
    def vertical_sprite?
      @orientation == :vertical
    end

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
      images = []

      list.to_a.each_with_index do |magick_image, index|
        image = Image.new(magick_image)
        padding = (index + 1) * spacing

        if vertical_sprite?
          image.top = sprite_position
          sprite_position -= image.height + padding
        else
          image.left = sprite_position
          sprite_position -= image.width + padding
        end
        images << image
      end
      images
    end
  end
end

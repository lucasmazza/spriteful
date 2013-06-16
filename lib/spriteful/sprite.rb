require 'rmagick'

module Spriteful
  class Sprite
    attr_reader :images, :combined_path

    def initialize(source, destination)
      sprite_name = source.split('/').last
      @combined_path = "#{File.join(destination, sprite_name)}.png"
      @images = Magick::ImageList.new(*Dir["#{source}/*png"])
    end

    def combine!
      images.each { |image| image.background_color = 'none' }
      combined = images.append(true)
      FileUtils.mkdir_p(File.dirname(combined_path))
      combined.write(combined_path)
    end
  end
end

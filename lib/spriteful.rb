require 'thor/error'

require 'spriteful/version'
require 'spriteful/image'
require 'spriteful/sprite'
require 'spriteful/stylesheet'

module Spriteful
  class EmptySourceError < Thor::Error; end

  class << self
    attr_accessor :options

    def optimize_svg?
      !options || !options.include?("--no-optimize-svg")
    end
  end
end

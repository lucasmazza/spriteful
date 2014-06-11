require 'thor/error'

require 'spriteful/version'
require 'spriteful/image'
require 'spriteful/optimizer'
require 'spriteful/sprite'
require 'spriteful/stylesheet'
require 'spriteful/template'

module Spriteful
  class EmptySourceError < Thor::Error; end

  class << self
    attr_accessor :options
  end
end

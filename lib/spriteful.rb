require 'thor/error'
require 'delegate'

require 'spriteful/version'
require 'spriteful/image'
require 'spriteful/optimizer'
require 'spriteful/sprite'
require 'spriteful/stylesheet'
require 'spriteful/template'
require 'spriteful/decorators/sprite'
require 'spriteful/decorators/image'

module Spriteful
  class EmptySourceError < Thor::Error; end

  class << self
    attr_accessor :options
  end
end

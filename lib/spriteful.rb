require 'thor/group'

require 'spriteful/sprite'
require 'spriteful/stylesheet'
require 'spriteful/thor/actions'
require 'spriteful/thor/shell'

module Spriteful
  class << self
    attr_accessor :shell
  end
end

Spriteful.shell = Spriteful::Thor::Shell.new

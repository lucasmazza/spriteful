require 'spriteful'

RSpec.configure do |config|
  config.order = 'random'

  config.after do
    Spriteful.options = nil
  end
end

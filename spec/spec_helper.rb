require 'spriteful'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.after do
    Spriteful.options = nil
  end
end

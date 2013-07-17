require 'spec_helper'

describe Spriteful::Image do
  let(:rmagick_image) { double('RMagick Image', filename: 'path/to/image.png', columns: 10, rows: 5) }
  subject(:image) { Spriteful::Image.new(rmagick_image) }

  it { expect(image.name).to eq('image.png') }
  it { expect(image.path).to eq('path/to/image.png') }
  it { expect(image.width).to eq(10) }
  it { expect(image.height).to eq(5) }
end

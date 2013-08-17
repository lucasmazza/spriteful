require 'spec_helper'

describe Spriteful::Image do
  let(:path) { 'path/to/image.png' }
  let(:chunky_image) { double('ChunkyPNG Image', width: 10, height: 5) }
  subject(:image) { Spriteful::Image.new(chunky_image, path) }

  it { expect(image.name).to eq('image.png') }
  it { expect(image.path).to eq('path/to/image.png') }
  it { expect(image.width).to eq(10) }
  it { expect(image.height).to eq(5) }
  it { expect(image.source).to eq(chunky_image) }
end

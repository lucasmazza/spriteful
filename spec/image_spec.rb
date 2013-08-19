require 'spec_helper'

describe Spriteful::Image do
  let(:magick_image) { double('Magick Image', filename: 'path/to/image.png', columns: 10, rows: 5) }
  subject(:image) { Spriteful::Image.new(magick_image) }

  it { expect(image.name).to eq('image.png') }
  it { expect(image.path).to eq('path/to/image.png') }
  it { expect(image.width).to eq(10) }
  it { expect(image.height).to eq(5) }
  it { expect(image.source).to eq(magick_image) }
  it { expect(image).to_not be_svg }
end

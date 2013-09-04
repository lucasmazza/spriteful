require 'spec_helper'

describe Spriteful::Image do
  let(:source_image) { double('Magick Image', filename: 'path/to/image.png', columns: 10, rows: 5) }
  subject(:image) { Spriteful::Image.new(source_image) }

  it { expect(image.name).to eq('image.png') }
  it { expect(image.path).to eq('path/to/image.png') }
  it { expect(image.width).to eq(10) }
  it { expect(image.height).to eq(5) }
  it { expect(image.source).to eq(source_image) }
  it { expect(image).to_not be_svg }

  context 'SVG images' do
    before do
      source_image.stub(filename: 'spec/fixtures/svg/green.svg')
    end

    it { expect(image).to be_svg }

    it 'returns the SVG XML as the #blob' do
      xml = SvgOptimizer.optimize(File.read(source_image.filename))
      expect(image.blob).to eq(xml)
    end
  end
end

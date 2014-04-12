require 'spec_helper'

describe Spriteful::Image do
  let(:filename) { 'path/to/image.png' }
  let(:source_image) { double('Magick Image', base_filename: filename, columns: 10, rows: 5) }
  subject(:image) { Spriteful::Image.new(source_image) }

  it { expect(image.name).to eq('image.png') }
  it { expect(image.path).to eq('path/to/image.png') }
  it { expect(image.width).to eq(10) }
  it { expect(image.height).to eq(5) }
  it { expect(image.source).to eq(source_image) }
  it { expect(image).to_not be_svg }

  context 'SVG images' do
    let(:filename) { 'spec/fixtures/svg/green.svg' }

    it { expect(image).to be_svg }

    it 'returns the optimized SVG XML as the #blob' do
      xml = SvgOptimizer.optimize(File.read(source_image.base_filename))
      expect(image.blob).to eq(xml)
    end

    context "skiping svg optimize" do
      before do
        Spriteful.options = ["--no-optimize-svg"]
      end

      it 'returns the unoptimized SVG XML as the #blob' do
        xml = File.read(source_image.base_filename)
        expect(image.blob).to eq(xml)
      end
    end
  end
end

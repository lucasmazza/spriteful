require 'fileutils'
require 'spec_helper'

describe Spriteful::Sprite do
  let(:source) { File.expand_path('spec/fixtures/simple') }
  let(:destination) { File.expand_path('tmp') }

  before { FileUtils.rm(Dir["#{destination}/*.png"]) }

  describe 'initialization' do
    it 'raises an error if the source directory is empty' do
      source = File.expand_path('spec/fixtures/missing')
      expect {
        Spriteful::Sprite.new(source, destination)
        }.to raise_error(Spriteful::EmptySourceError)
    end
  end

  describe '#width' do
    it 'returns the whole sprite width' do
      sprite = Spriteful::Sprite.new(source, destination)
      expect(sprite.width).to be(10)
    end

    it 'accounts for the padding information' do
      sprite = Spriteful::Sprite.new(source, destination, spacing: 10, horizontal: true)
      expect(sprite.width).to be(30)
    end
  end

  describe '#height' do
    it 'returns the whole sprite height' do
      sprite = Spriteful::Sprite.new(source, destination)
      expect(sprite.height).to be(20)
    end

    it 'accounts for the spacing information' do
      sprite = Spriteful::Sprite.new(source, destination, spacing: 10)
      expect(sprite.height).to be(30)
    end
  end

  describe '#path' do
    it 'returns the path where the combined image will be saved' do
      sprite = Spriteful::Sprite.new(source, destination)
      expect(sprite.path).to eq(File.expand_path('tmp/simple.png'))
    end
  end

  describe '#filename' do
    it 'returns the filename of the sprite combined image' do
      sprite = Spriteful::Sprite.new(source, destination)
      expect(sprite.filename).to eq('simple.png')
    end
  end

  describe '#combine!' do
    it 'sets the sprite blob' do
      sprite = Spriteful::Sprite.new(source, destination)
      sprite.combine!
      expect(sprite.blob).to be
    end

    it 'combine images vertically by default' do
      sprite = Spriteful::Sprite.new(source, destination)
      sprite.combine!
      image = Magick::Image.from_blob(sprite.blob).first
      expect(image.columns).to be(10)
      expect(image.rows).to be(20)
    end

    it 'can combine images horizontally' do
      sprite = Spriteful::Sprite.new(source, destination, horizontal: true)
      sprite.combine!
      image = Magick::Image.from_blob(sprite.blob).first
      expect(image.columns).to be(20)
      expect(image.rows).to be(10)
    end
  end

  describe '#images' do
    it 'yields an object for each image found in the source directory' do
      sprite = Spriteful::Sprite.new(source, destination)
      blue, red = sprite.images.to_a

      expect(blue.name).to eq('blue.png')
      expect(blue.top).to eq(0)
      expect(blue.left).to eq(0)

      expect(red.name).to eq('red.png')
      expect(red.top).to eq(-10)
      expect(red.left).to eq(0)
    end

    it 'accounts the spacing option when setting the "left" attribute of each image on a horizontal sprite' do
      sprite = Spriteful::Sprite.new(source, destination, spacing: 10, horizontal: true)
      blue, red = sprite.images.to_a

      expect(blue.top).to eq(0)
      expect(blue.left).to eq(0)

      expect(red.top).to eq(0)
      expect(red.left).to eq(-20)
    end

    it 'accounts the spacing option when setting the "top" attribute of each image' do
      sprite = Spriteful::Sprite.new(source, destination, spacing: 10)
      blue, red = sprite.images.to_a

      expect(blue.top).to eq(0)
      expect(blue.left).to eq(0)

      expect(red.top).to eq(-20)
      expect(red.left).to eq(0)
    end
  end

  describe 'svg support' do
    let(:source) { File.expand_path('spec/fixtures/svg') }

    it 'identifies svg images inside the sprite' do
      sprite = Spriteful::Sprite.new(source, destination)
      expect(sprite).to have(1).svgs
    end
  end
end

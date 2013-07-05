require 'fileutils'
require 'spec_helper'

describe Spriteful::Sprite do
  let(:source) { File.expand_path('spec/fixtures/simple') }
  let(:destination) { File.expand_path('tmp') }

  describe 'initialization' do
    it 'raises an error if the source directory is empty' do
      source = File.expand_path('spec/fixtures/missing')
      expect {
        Spriteful::Sprite.new(source, destination)
        }.to raise_error(Spriteful::EmptySourceError)
    end
  end

  describe '#path' do
    it 'returns the path where the combined image will be saved' do
      sprite = Spriteful::Sprite.new(source, destination)
      expect(sprite.path).to eq(File.expand_path('tmp/simple.png'))
    end
  end

  describe '#combine!' do
    it 'sets the sprite blob' do
      sprite = Spriteful::Sprite.new(source, destination)
      sprite.combine!
      expect(sprite.blob).to be
    end
  end

  describe '#images' do
    it 'yields an object for each image found in the source directory' do
      sprite = Spriteful::Sprite.new(source, destination)
      image = sprite.images.first

      expect(image.name).to eq('blue.png')
      expect(image.width).to eq(10)
      expect(image.height).to eq(10)
      expect(image.path).to eq(File.join(source, 'blue.png'))
    end
  end
end

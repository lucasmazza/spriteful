require 'fileutils'
require 'spec_helper'

describe Spriteful::Sprite do
  let(:source) { File.expand_path('spec/fixtures/simple') }
  let(:destination) { File.expand_path('tmp') }

  describe '#path' do
    it 'returns the path where the combined image will be saved' do
      sprite = Spriteful::Sprite.new(source, destination)
      expect(sprite.path).to eq(File.expand_path('tmp/simple.png'))
    end
  end

  describe '#combine!' do
    it 'combines the source images into a single image' do
      sprite = Spriteful::Sprite.new(source, destination)
      combined = sprite.combine!
      expect(File.exist?(combined.path)).to be
    end

    it 'creates the destination directory if necessary' do
      missing_destination = File.expand_path('tmp/missing')
      FileUtils.rm_rf(missing_destination)
      sprite = Spriteful::Sprite.new(source, missing_destination)
      sprite.combine!
      expect(File.exist?(File.expand_path('tmp/missing/simple.png'))).to be
    end
  end

  describe '#each_image' do
    it 'yields an object for each image found in the source directory' do
      sprite = Spriteful::Sprite.new(source, destination)
      image = sprite.each_image.to_a.first

      expect(image.name).to eq('blue.png')
      expect(image.width).to eq(10)
      expect(image.height).to eq(10)
      expect(image.path).to eq(File.join(source, 'blue.png'))
    end
  end
end

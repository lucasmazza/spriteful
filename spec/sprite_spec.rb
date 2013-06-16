require 'fileutils'
require 'spec_helper'

describe Spriteful::Sprite do
  it 'expose the source images' do
    sprite = Spriteful::Sprite.new(File.expand_path('spec/fixtures/simple'), File.expand_path('tmp'))
    first = sprite.images[0]
    second = sprite.images[1]

    expect(File.basename(first.filename)).to eq('blue.png')
    expect(File.basename(second.filename)).to eq('red.png')
  end

  it 'exposes the combined image path' do
    sprite = Spriteful::Sprite.new(File.expand_path('spec/fixtures/simple'), File.expand_path('tmp'))
    expect(sprite.combined_path).to eq(File.expand_path('tmp/simple.png'))
  end

  describe '#combine!' do
    let(:source) { File.expand_path('spec/fixtures/simple') }

    it 'combines the source images into a single image' do
      sprite = Spriteful::Sprite.new(source, File.expand_path('tmp'))
      sprite.combine!
      expect(File.exist?(File.expand_path('tmp/simple.png'))).to be
    end

    it 'creates the destination directory if necessary' do
      missing_dir = File.expand_path('tmp/missing')
      FileUtils.rm_rf(missing_dir)
      sprite = Spriteful::Sprite.new(source, missing_dir)
      sprite.combine!
      expect(File.exist?(File.expand_path('tmp/missing/simple.png'))).to be
    end
  end
end

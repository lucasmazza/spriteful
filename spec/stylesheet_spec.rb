require 'spec_helper'

describe Spriteful::Stylesheet do
  let(:source) { File.expand_path('spec/fixtures/simple') }
  let(:destination) { File.expand_path('tmp') }
  let(:sprite) { sprite = Spriteful::Sprite.new(source, destination) }

  describe '#render' do
    it 'renders the CSS for the given sprite' do
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, 'css')
      output = stylesheet.render

      expect(output).to match(/.simple \{/)
      expect(output).to match(/.simple.blue \{/)
      expect(output).to match(/.simple.red \{/)
    end
    it 'renders the SCSS format' do
      sprite = Spriteful::Sprite.new(source, destination)
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, 'scss')
      output = stylesheet.render

      expect(output).to match(/%simple-sprite-blue \{/)
      expect(output).to match(/%simple-sprite-red \{/)
    end
  end

  describe '#write' do
    it 'stores the stylesheet contents in the supplied destination' do
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, 'css')
      stylesheet.write(destination)
      stylesheet_path = File.join(destination, 'simple.css')

      expect(File.exist?(stylesheet_path)).to be
    end

    it 'uses the supplied format as the stylesheet extension' do
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, 'scss')
      stylesheet.write(destination)
      stylesheet_path = File.join(destination, 'simple.scss')

      expect(File.exist?(stylesheet_path)).to be
    end
  end
end

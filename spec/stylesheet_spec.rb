require 'spec_helper'

describe Spriteful::Stylesheet do
  let(:source) { File.expand_path('spec/fixtures/simple') }
  let(:destination) { File.expand_path('tmp') }
  let(:sprite) { Spriteful::Sprite.new(source, destination) }

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
end

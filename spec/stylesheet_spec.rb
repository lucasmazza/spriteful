require 'spec_helper'

describe Spriteful::Stylesheet do
  let(:source) { File.expand_path('spec/fixtures/simple') }
  let(:destination) { File.expand_path('tmp') }
  let(:sprite) { Spriteful::Sprite.new(source, destination) }

  describe '#render' do
    it 'renders the CSS for the given sprite' do
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, format: 'css')
      output = stylesheet.render

      expect(output).to match(/.simple \{/)
      expect(output).to match(/.simple.blue \{/)
      expect(output).to match(/.simple.red \{/)
    end

    it 'renders the SCSS format' do
      sprite = Spriteful::Sprite.new(source, destination)
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, format: 'scss')
      output = stylesheet.render

      expect(output).to match(/%simple-sprite \{/)
      expect(output).to match(/%simple-sprite-blue \{/)
      expect(output).to match(/%simple-sprite-red \{/)
    end

    it 'renders the SCSS format using mixin' do
      sprite = Spriteful::Sprite.new(source, destination)
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, format: 'scss', mixin: true)
      output = stylesheet.render

      expect(output).to match(/@mixin simple-sprite \{/)
      expect(output).to match(/@mixin simple-sprite-blue \{/)
      expect(output).to match(/@include simple-sprite;/)
      expect(output).to match(/@mixin simple-sprite-red \{/)
    end

    it 'renders a SCSS variable with the all the images in the sprite' do
      sprite = Spriteful::Sprite.new(source, destination)
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, format: 'scss', mixin: true)
      output = stylesheet.render

      expect(output).to match(/\$simple-sprite-names\: blue red/)
    end

    it 'documents the Spriteful options used to generate the stylesheet' do
      Spriteful.options = %w(one two three)
      sprite = Spriteful::Sprite.new(source, destination)
      stylesheet = Spriteful::Stylesheet.new(sprite, destination, format: 'css')
      output = stylesheet.render

      expect(output).to match(/'spriteful one two three'/)
    end

    describe 'SVG support' do
      let(:source) { File.expand_path('spec/fixtures/svg') }

      it 'exposes an alternative class for browsers that support SVG' do
        stylesheet = Spriteful::Stylesheet.new(sprite, destination, format: 'css')
        output = stylesheet.render

        expect(output).to match(/^.svg.green \{/)
        expect(output).to match(/^.svg .svg.green \{/)
      end

      it 'extends the placeholder selectors for browsers that support SVG' do
        stylesheet = Spriteful::Stylesheet.new(sprite, destination, format: 'scss')
        output = stylesheet.render

        expect(output).to match(/^  .svg & \{/)
      end
    end
  end
end

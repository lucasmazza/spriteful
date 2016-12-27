require 'spec_helper'

describe Spriteful::Template do
  let(:sprite) { double }
  let(:options) { { destination: File.expand_path('tmp/output') } }
  subject(:template) { Spriteful::Template.new(sprite, options) }

  describe '#cli_options' do
    it 'returns the cli_options provided in the options' do
      options[:cli_options] = %w(one two three)
      expect(template.cli_options).to eq(%w(one two three))
    end
  end

  describe '#class_name_for' do
    it 'formats the object name into a suitable CSS selector name' do
      thing = double(name: 'Thing_name.jpg')
      expect(template.class_name_for(thing)).to eq('thing-name')
    end
  end

  describe '#extension_prefix' do
    it 'returns the prefix to be used when defining the sprite CSS selector' do
      expect(template.extension_prefix).to eq('%')
      options[:mixin] = true
      expect(template.extension_prefix).to eq('@mixin ')
    end
  end

  describe '#extension_strategy' do
    it 'returns prefix to be used when extending the SCSS selector' do
      expect(template.extension_strategy).to eq('@extend %')
      options[:mixin] = true
      expect(template.extension_strategy).to eq('@include ')
    end
  end

  describe '#mixin?' do
    it 'returns true when the :mixin flag is true' do
      options[:mixin] = true
      expect(template.mixin?).to be(true)
    end
  end

  describe '#scale?' do
    it 'returns true when the :scale flag is true' do
      options[:scale] = true
      expect(template.scale?).to be(true)
    end
  end

  describe '#rails?' do
    it 'returns true when the :rails flag is true' do
      options[:rails] = true
      expect(template.rails?).to be(true)
    end
  end

  describe '#image_url' do
    it 'returns a path under sprites when the :rails flag is present' do
      sprite = double(path: '/path', filename: 'icons.png')
      options[:rails] = true

      expect(template.image_url(sprite)).to eq('sprites/icons.png')
    end

    it 'returns an absolute path when the :root option is given' do
      sprite = double(path: File.expand_path('tmp/sprites/icons.png'))
      options[:root] = Pathname.new(File.expand_path('tmp'))

      expect(template.image_url(sprite)).to eq('/sprites/icons.png')
    end

    it 'returns the sprite path relative to the destination path' do
      sprite = double(path: File.expand_path('tmp/sprites/icons.png'))

      expect(template.image_url(sprite)).to eq('../sprites/icons.png')
    end
  end

  describe '#data_uri' do
    it 'returns a Base64 encoded String for the SVG image' do
      image = double(svg?: true, blob: '<svg />')
      expect(template.data_uri(image)).to eq("'data:image/svg+xml;base64,PHN2ZyAvPg=='")
    end
  end

  describe '#render' do
    it 'renders the given ERB string in the template context' do
      erb = 'ZOMG <%= self.class.name %>'

      expect(template.render(erb)).to eq('ZOMG Spriteful::Template')
    end
  end
end

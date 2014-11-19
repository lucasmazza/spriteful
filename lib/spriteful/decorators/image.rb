module Spriteful
  module Decorators
    class Image < SimpleDelegator
      attr_reader :template
      private :template

      attr_reader :sprite
      private :sprite

      def initialize(template, sprite, image)
        @template = template
        @sprite = sprite
        __setobj__ image
      end

      def class_name
        template.class_name_for(image)
      end

      def background_position
        "#{image.left}px #{image.top}px"
      end

      def selector
        send "selector_for_#{template.format}"
      end

      def data_uri
        template.data_uri(image)
      end

      private

      def image
        __getobj__
      end

      def selector_for_css
        ".#{sprite.class_name}.#{class_name}"
      end

      def selector_for_scss
        %[#{sprite.class_name}-#{class_name}]
      end
    end
  end
end

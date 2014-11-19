module Spriteful
  module Decorators
    class Sprite < SimpleDelegator
      attr_reader :template
      private :template

      def initialize(template, sprite)
        @template = template
        __setobj__ sprite
      end

      def class_name
        send "class_name_for_#{template.format}"
      end

      def background_image
        send "background_image_for_#{template.format}"
      end

      def extension
        %[#{template.extension_strategy}#{class_name_for_css}-sprite;]
      end

      def var_with_name_list
        names = sprite.images.map { |i| template.class_name_for(i) }.join(' ')
        %[$#{class_name_for_css}-sprite-names: #{names};]
      end

      private

      def sprite
        __getobj__
      end

      def class_name_for_css
        template.class_name_for(sprite)
      end

      def class_name_for_scss
        "#{template.extension_prefix}#{class_name_for_css}-sprite"
      end

      def background_image_for_css
        url = template.image_url(sprite)

        if template.rails?
          %[<%= image_url('#{url}') %>]
        else
          %[url('#{url}')]
        end
      end

      def background_image_for_scss
        url = template.image_url(sprite)

        if template.rails?
          %[image-url('#{url}')]
        else
          %[url('#{url}')]
        end
      end
    end
  end
end

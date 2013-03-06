module Creamerscript
  module Sweeteners
    class PropertyInvocation < Base
      def pattern
        /\(#{SYMBOL} #{SYMBOL}\)/
      end

      def to_coffee
        "#{subject}.#{property_name}"
      end

      def subject
        body.split.first
      end

      def property_name
        body.split.last
      end

      private

      def body
        source[1..-2]
      end
    end
  end
end

module Creamerscript
  module Transformers
    class PropertyInvocation
      attr_accessor :source

      def initialize(source)
        @source = source
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

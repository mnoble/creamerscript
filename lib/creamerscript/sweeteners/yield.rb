module Creamerscript
  module Sweeteners
    class Yield < Base
      def pattern
        /yield .*$/
      end

      def to_coffee
        "block(#{arguments})"
      end

      def arguments
        source.split("yield ").last
      end
    end
  end
end

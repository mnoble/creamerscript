module Creamerscript
  module Sweeteners
    class Object < Base
      def pattern
        /{#{SYMBOL}:[^{}]+}/
      end
    end
  end
end

module Creamerscript
  module Sweeteners
    class Object < Base
      def pattern
        /{[^{}]+}/
      end
    end
  end
end

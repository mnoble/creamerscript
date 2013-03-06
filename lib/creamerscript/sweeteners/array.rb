module Creamerscript
  module Sweeteners
    class Array < Base
      def pattern
        /\[[^\[\]]+\]/
      end
    end
  end
end

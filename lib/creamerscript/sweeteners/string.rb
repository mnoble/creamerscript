module Creamerscript
  module Sweeteners
    class String < Base
      def pattern
        /"(?:[^"\\]|\\.)*"/
      end
    end
  end
end

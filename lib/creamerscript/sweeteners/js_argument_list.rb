module Creamerscript
  module Sweeteners
    class JSArgumentList < Base
      def pattern
        /:(#{SYMBOL},\s*[#{SYMBOL}\.,\s]*)\)/
      end

      def tokenize(source)
        source.gsub!(pattern) { |match| match.gsub!($1, push(substitute($1))) }
      end
    end
  end
end

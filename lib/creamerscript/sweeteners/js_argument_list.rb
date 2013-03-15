module Creamerscript
  module Sweeteners
    class JSArgumentList < Base
      def pattern
        /:(#{SYMBOL},\s*[#{SYMBOL}\.,\s]*)\)/
      end

      def substitute(source)
        source.gsub!(pattern) { |match| match.gsub($1, tokenize($1)) }
      end
    end
  end
end

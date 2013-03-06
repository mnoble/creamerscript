module Creamerscript
  module Sweeteners
    class JSArgumentList < Base
      def substitute(source)
        source.gsub!(pattern) { |match| match.gsub($1, swap($1)) } while source =~ pattern
      end

      def pattern
        /\(#{SYMBOL} #{SYMBOL}:(#{SYMBOL},\s*[#{SYMBOL},\s]*)\)/
      end
    end
  end
end

module Creamerscript
  module Sweeteners
    class Block < Base
      def pattern
        /\)\s?{[^{}]+}/
      end

      def substitute(source)
        source.gsub!(pattern) { |match| ":#{tokenize(match)})" }
      end

      def to_coffee
        "(#{arguments.join(", ")}) ->#{body}"
      end

      def arguments
        without_delimeters.split("|").first.strip.split
      end

      def body
        without_delimeters.split("|").last.rstrip
      end

      def without_delimeters
        source[/{([^}]+)}/, 1]
      end
    end
  end
end

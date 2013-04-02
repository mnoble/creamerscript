module Creamerscript
  module Sweeteners
    class Base
      SYMBOL = /[A-Za-z0-9$_@]+/

      attr_accessor :substitutions, :source

      def initialize
        @substitutions = {}
      end

      def call(id)
        @source = substitutions[id]
      end

      def to_coffee
        source
      end

      def tokenize(source)
        source.gsub!(pattern) { |match| push(substitute(match)) }
      end

      def substitute(source)
        while sweetener = Sweeteners.match(source, self)
          sweetener.tokenize(source) 
        end
        source
      end

      def push(substitution)
        token.tap { substitutions[substitutions.size] = substitution }
      end

      def token
        "_____CREAMER_#{type.upcase}_#{substitutions.size}_____"
      end

      def type
        self.class.name.split("::").last.underscore.to_sym
      end
    end
  end
end

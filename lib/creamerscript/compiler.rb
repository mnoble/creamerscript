module Creamerscript
  # Compiles CreamerScript code to Coffeescript.
  #
  # The Compiler itself doesn't really do much. It's just a 
  # structured way of parsing code and then transforming it
  # into Coffeescript.
  #
  # Sweeteners are the real workers of CreamerScript. Take a
  # look at the the creamerscript-sweeteners project for more
  # info.
  #
  # @example
  #
  #   compiler = Creamerscript::Compiler.new "(person say:'Hello')"
  #   compiler.compile
  #   # => "person.say("hello")
  #
  class Compiler
    attr_accessor :source

    def initialize(source)
      @source = source.dup
    end

    def compile
      substitute
      source.tap { transform(source) }
    end

    def substitute
      Sweeteners.each do |sweetener|
        sweetener.substitute(source) while source =~ sweetener.pattern
      end
    end

    def transform(source)
      source.gsub!(pattern) do |sub|
        sweetener = Sweeteners.for($1.downcase.to_sym)
        sweetener.call($2.to_i)

        result = sweetener.to_coffee
        result = transform(result) if result =~ pattern
        result
      end
    end

    def pattern
      /_____CREAMER_([A-Z_]+)_(\d+)_____/
    end
  end
end

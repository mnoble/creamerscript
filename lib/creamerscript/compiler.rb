module Creamerscript
  # Transforms substituted source into its final Coffeescript form.
  #
  # Finds all occurences of a CreamerScript token, described as
  # +SUBSTITUTION+, and transforms its value into CoffeeScript. For
  # strings, arrays, objects and JavaScript argument arrays this 
  # nothing changes. They're just replaced directly. For CreamerScript 
  # method/property invocations, this means transforming into 
  # CoffeeScript/JavaScript syntax.
  #
  # @example Method Invocations
  #
  #   (console log:"Hello World")
  #   # => console.log("Hello World")
  #
  # @example Method Invocations with no arguments
  #
  #   (this say_hello:)
  #   # => this.say_hello()
  #
  # @example Property Invocations
  #
  #   (person name)
  #   # => person.name
  #
  # @example JavaScript-Defined Method Invocations
  #
  #   (node getFeature:feature, version)
  #   # => node.getFeature(feature, version)
  #
  # @example Constructor Method Invocations
  #
  #   (Date new:"2013-03-01")
  #   # => new Date("2013-03-01)
  #
  class Compiler
    attr_accessor :source

    def initialize(source)
      @source = source.dup
    end

    def compile
      substitute
      transform(source)
    end

    def substitute
      Sweeteners.each { |sweetener| sweetener.substitute(source) }
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

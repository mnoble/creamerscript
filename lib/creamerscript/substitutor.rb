module Creamerscript
  # Replaces object literals, JavaScript argument lists and
  # CreamerScript Method/Property invocations with tokens.
  #
  # Elements are replaced with tokens so that parsing and transforming
  # invocations is easier. Invocations in the resulting source are
  # easier to parse, since there are no nested arrays, objects or
  # iother invocations. They all act as "top-level" invocations.
  #
  # @example Step by step substitution
  #
  #     1. (this do_thing:["A", (this stuff)])
  #
  #     2. (this do_thing:[_____CREAMER_STRING_0_____, (this stuff)])
  #        _____CREAMER_STRING_0_____ = '"A"'
  #
  #     3. (this do_thing:[_____CREAMER_STRING_0_____, _____CREAMER_INVOCATION_0_____])
  #        _____CREAMER_INVOCATION_0_____ = "(this stuff)"
  #
  #     4. (this do_thing:_____CREAMER_ARRAY_0_____)
  #        _____CREAMER_ARRAY_0_____ = [_____CREAMER_STRING_0_____, _____CREAMER_INVOCATION_0_____]
  #
  #     5. _____CREAMER_INVOCATION_1_____
  #
  class Substitutor
    SYMBOL           = /[A-Za-z0-9$_@]+/
    STRING           = /"(?:[^"\\]|\\.)*"/
    ARRAY            = /\[[^\[\]]+\]/
    OBJECT           = /{[^{}]+}/
    PROPERTY         = /\(#{SYMBOL} #{SYMBOL}\)/
    INVOCATION       = /\(#{SYMBOL} #{SYMBOL}[^\(\)]+\)/m
    JS_ARGUMENT_LIST = /\(#{SYMBOL} #{SYMBOL}:(#{SYMBOL},\s*[#{SYMBOL},\s]*)\)/
    DEFINITION       = /def #{SYMBOL}(?::#{SYMBOL})?(?:\s+#{SYMBOL}:#{SYMBOL})*/

    # @!attribute [rw] strings
    #   List of String literal values that were replaces with tokens
    attr_accessor :strings

    # @!attribute [rw] arrays
    #   List of Array literal values that were replaces with tokens
    attr_accessor :arrays

    # @!attribute [rw] objects
    #   List of Object literal values that were replaces with tokens
    attr_accessor :objects

    # @!attribute [rw] invocations
    #   List of Method Invocation values that were replaces with tokens
    attr_accessor :invocations

    # @!attribute [rw] properties
    #   List of Property Invocation values that were replaces with tokens
    attr_accessor :properties

    # @!attribute [rw] js_argument_lists
    #   List of JavaScript Argument List values that were replaces with tokens
    attr_accessor :js_argument_lists

    # @!attribute [rw] definitions
    #   List of Method Definition values that were replaces with tokens
    attr_accessor :definitions


    def initialize
      @strings = {}
      @arrays = {}
      @objects = {}
      @invocations = {}
      @properties = {}
      @js_argument_lists = {}
      @definitions = {}
    end

    # Replaces all invocations, and other elements there within,
    # depth first. That means it will replace an invocation without any
    # nested invocations first. Then move up through the +source+.
    #
    # @param [String] source The CreamerScript to substitute.
    #
    def sub!(source)
      sub_invocations(source) while source =~ INVOCATION
      sub_definitions(source) while source =~ DEFINITION
    end

    # Finds all occurences of an invocation without any nested
    # invocations. Inside that, it replaces all other elements that can
    # potentially have nested elements, ie: Strings, Arrays, Objects and
    # JavaScript Argument Lists.
    #
    # @param [String] source The CreamerScript to substitute.
    #
    def sub_invocations(source)
      source.gsub!(INVOCATION) do |expr|
        sub_string(expr)           while expr =~ STRING
        sub_array(expr)            while expr =~ ARRAY
        sub_object(expr)           while expr =~ OBJECT
        sub_js_argument_list(expr) while expr =~ JS_ARGUMENT_LIST

        type, collection = determine_property_or_invocation(expr)
        token(type, collection).tap { collection[collection.size] = expr }
      end
    end

    def determine_property_or_invocation(expr)
      expr =~ PROPERTY ? [:PROPERTY, properties] : [:INVOCATION, invocations]
    end

    # Replaces string literals.
    #
    # @example
    #
    #   (console log:"Hello World")
    #   # => (console log:_____CREAMER_STRING_0_____)
    #
    #   strings
    #   # => {0=>"\"Hello World\""}
    #
    def sub_string(source)
      sub_type(source, :STRING, strings)
    end

    # Replaces array literals.
    #
    # @example
    #
    #   (console log:[1, 2, 3])
    #   # => (console log:_____CREAMER_ARRAY_0_____)
    #
    #   arrays
    #   # => {0=>"[1, 2, 3]}
    #
    def sub_array(source)
      sub_type(source, :ARRAY, arrays)
    end

    # Replaces object literals.
    #
    # @example
    #
    #   (console log:{a: 1})
    #   # => (console log:_____CREAMER_OBJECT_0_____)
    #
    #   objects
    #   # => {0=>"{a: 1}"}
    #
    def sub_object(source)
      sub_type(source, :OBJECT, objects)
    end

    # Replaces regular JavaScript arguments lists.
    #
    # @example
    #
    #   (_ invoke:arg1, arg2, arg3)
    #   # => (_ invoke:_____CREAMER_JS_ARGUMENT_LIST_0_____)
    #
    #   js_argument_lists
    #   # => {0=>"arg1, arg2, arg3"}
    #
    def sub_js_argument_list(source)
      source.gsub!(JS_ARGUMENT_LIST) do |match|
        match.gsub($1, token(:JS_ARGUMENT_LIST, js_argument_lists).tap { js_argument_lists[js_argument_lists.size] = $1 })
      end
    end

    # Replace all method definitions.
    #
    # @example
    #
    #   def foo:bar beep:boop
    #   # => _____CREAMER_DEFINITION_0_____
    #
    #   definitions
    #   # => {0=>"def foo:bar beep:boop"}
    #
    def sub_definitions(source)
      sub_type(source, :DEFINITION, definitions)
    end

    private

    def sub_type(source, type, collection)
      source.gsub!(pattern(type)) { |match| token(type, collection).tap { collection[collection.size] = match }}
    end

    def pattern(type)
      self.class.const_get(type)
    end

    def token(type, collection)
      "_____CREAMER_#{type}_#{collection.size}_____"
    end
  end
end

module Creamerscript
  class Substitutor
    SYMBOL           = /[A-Za-z0-9$_@]+/
    STRING           = /"(?:[^"\\]|\\.)*"/
    ARRAY            = /\[[^\[\]]+\]/
    OBJECT           = /{[^{}]+}/
    PROPERTY         = /\(#{SYMBOL} #{SYMBOL}\)/
    INVOCATION       = /\(#{SYMBOL} #{SYMBOL}[^\(\)]+\)/m
    JS_ARGUMENT_LIST = /\(#{SYMBOL} #{SYMBOL}:(#{SYMBOL},\s*[#{SYMBOL},\s]*)\)/

    attr_accessor :strings, :arrays, :objects, :invocations, :properties, :js_argument_lists

    def initialize
      @strings           = {}
      @arrays            = {}
      @objects           = {}
      @invocations       = {}
      @properties        = {}
      @js_argument_lists = {}
    end

    def sub!(source)
      sub_invocations(source) while source =~ INVOCATION
    end

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

    def sub_js_argument_list(source)
      source.gsub!(JS_ARGUMENT_LIST) do |match|
        match.gsub($1, token(:JS_ARGUMENT_LIST, js_argument_lists).tap { js_argument_lists[js_argument_lists.size] = $1 })
      end
    end

    def sub_string(source)
      sub_type(source, :STRING, strings)
    end

    def sub_array(source)
      sub_type(source, :ARRAY, arrays)
    end

    def sub_object(source)
      sub_type(source, :OBJECT, objects)
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

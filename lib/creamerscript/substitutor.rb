module Creamerscript
  class Substitutor
    STRING     = /"(?:[^"\\]|\\.)*"/
    ARRAY      = /\[[^\[\]]+\]/
    OBJECT     = /{[^{}]+}/
    INVOCATION = /\([A-Za-z0-9$_@]+ [A-Za-z0-9$_@]+[^\(\)]+\)/m
    PROPERTY   = /\([A-Za-z0-9$_@]+ [A-Za-z0-9$_@]+\)/

    attr_accessor :strings, :arrays, :objects, :invocations, :properties

    def initialize
      @strings     = {}
      @arrays      = {}
      @objects     = {}
      @invocations = {}
      @properties  = {}
    end

    def sub!(source)
      sub_invocations(source) while source =~ INVOCATION
    end

    def sub_invocations(source)
      source.gsub!(INVOCATION) do |expr|
        sub_string(expr) while expr =~ STRING
        sub_array(expr)  while expr =~ ARRAY
        sub_object(expr) while expr =~ OBJECT

        type, collection = (expr =~ PROPERTY) ? [:PROPERTY, properties] : [:INVOCATION, invocations]
        token(type, collection).tap { collection[collection.size] = expr }
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

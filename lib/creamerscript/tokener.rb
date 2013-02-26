module Creamerscript
  class Tokener
    INTEGER = /\d+/
    FLOAT   = /\d+\.\d+/
    STRING  = /"(?:[^"\\]|\\.)*"/
    ARRAY   = /\[[^\[\]]+\]/
    OBJECT  = /{[^{}]+}/

    attr_accessor :integers, :floats, :strings, :arrays, :objects

    def initialize
      @integers = {}
      @floats   = {}
      @strings  = {}
      @arrays   = {}
      @objects  = {}
    end

    def sub_integers(source)
      sub_type(source, :INTEGER, integers)
    end

    def sub_float(source)
      sub_type(source, :FLOAT, floats)
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

    def sub_type(source, type, collection)
      source.gsub(self.class.const_get(type)) do |match|
        "_____CREAMER_#{type}_#{collection.size}_____".tap { collection[collection.size] = match }
      end
    end
  end
end

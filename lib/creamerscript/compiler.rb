module Creamerscript
  class Compiler
    SUBSTITUTION = /_____CREAMER_([A-Z]+)_(\d+)_____/

    attr_accessor :substitutor

    def initialize
      @substitutor = Substitutor.new
    end

    def compile(source)
      substitutor.sub!(source)
      transform(source)
    end

    def transform(source)
      source.gsub(SUBSTITUTION) do |sub|
        type   = $1.downcase
        id     = $2.to_i
        result = send(:"transform_#{type}", sub)
        result = transform(result) if result.match(SUBSTITUTION)
        result
      end
    end

    def transform_invocation(source)
      invocation = invocations[id(source, :INVOCATION)]
      MethodInvocation.new(invocation).to_coffee
    end

    def transform_property(source)
      property = properties[id(source, :PROPERTY)]
      PropertyInvocation.new(property).to_coffee
    end

    def transform_array(source)
      arrays[id(source, :ARRAY)]
    end

    def transform_string(source)
      strings[id(source, :STRING)]
    end

    def transform_object(source)
      objects[id(source, :OBJECT)]
    end

    def id(source, type)
      source.scan(/_____CREAMER_#{type}_(\d+)_____/)[0][0].to_i
    end

    def invocations
      substitutor.invocations
    end

    def arrays
      substitutor.arrays
    end

    def strings
      substitutor.strings
    end

    def objects
      substitutor.objects
    end

    def properties
      substitutor.properties
    end
  end
end

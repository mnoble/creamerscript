module Creamerscript
  class Compiler
    SUBSTITUTION = /_____CREAMER_([A-Z_]+)_(\d+)_____/

    attr_accessor :substitutor

    def initialize
      @substitutor = Substitutor.new
    end

    def compile(source)
      source = source.dup
      substitutor.sub!(source)
      transform(source)
    end

    def transform(source)
      source.gsub!(SUBSTITUTION) do |sub|
        result = send(:"transform_#{$1.downcase}", sub)
        result = transform(result) if result.match(SUBSTITUTION)
        result
      end
    end

    def transform_invocation(source)
      invocation = invocations[id(source, :INVOCATION)]
      Transformers::MethodInvocation.new(invocation).to_coffee
    end

    def transform_property(source)
      property = properties[id(source, :PROPERTY)]
      Transformers::PropertyInvocation.new(property).to_coffee
    end

    def transform_js_argument_list(source)
      js_argument_lists[id(source, :JS_ARGUMENT_LIST)]
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

    private

    def id(source, type)
      source.scan(/_____CREAMER_#{type}_(\d+)_____/)[0][0].to_i
    end

    def invocations
      substitutor.invocations
    end

    def properties
      substitutor.properties
    end

    def js_argument_lists
      substitutor.js_argument_lists
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
  end
end

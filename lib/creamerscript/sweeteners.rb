require "active_support/inflector"
require "creamerscript/sweeteners"
require "creamerscript/sweeteners/base"
require "creamerscript/sweeteners/array"
require "creamerscript/sweeteners/js_argument_list"
require "creamerscript/sweeteners/method_definition"
require "creamerscript/sweeteners/method_invocation"
require "creamerscript/sweeteners/object"
require "creamerscript/sweeteners/string"
require "creamerscript/sweeteners/block"
require "creamerscript/sweeteners/yield"

module Creamerscript
  module Sweeteners
    def self.register(sweetener)
      sweetener.new.tap { |s| sweeteners[s.type] = s }
    end

    def self.each
      sweeteners.each { |type, sweetener| yield sweetener }
    end

    def self.match(source, exclude=nil)
      sweeteners.values.find do |sweetener|
        next if sweetener.is_a?(exclude.class)
        source =~ sweetener.pattern
      end
    end

    def self.for(type)
      sweeteners[type]
    end

    def self.sweeteners
      @sweeteners ||= {}
    end
  end
end

Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::String)
Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::Object)
Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::Array)
Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::JSArgumentList)
Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::Yield)
Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::Block)
Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::MethodInvocation)
Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::MethodDefinition)

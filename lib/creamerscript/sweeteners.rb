require "creamerscript/sweeteners/base"
require "creamerscript/sweeteners/array"
require "creamerscript/sweeteners/js_argument_list"
require "creamerscript/sweeteners/method_definition"
require "creamerscript/sweeteners/method_invocation"
require "creamerscript/sweeteners/object"
require "creamerscript/sweeteners/property_invocation"
require "creamerscript/sweeteners/string"

module Creamerscript
  module Sweeteners
    def self.register(sweetener)
      sweetener.new.tap { |s| sweeteners[s.type] = s }
    end

    def self.each
      sweeteners.each { |type, sweetener| yield sweetener }
    end

    def self.for(type)
      sweeteners[type]
    end

    def self.sweeteners
      @sweeteners ||= {}
    end

    register(Creamerscript::Sweeteners::String)
    register(Creamerscript::Sweeteners::Object)
    register(Creamerscript::Sweeteners::Array)
    register(Creamerscript::Sweeteners::PropertyInvocation)
    register(Creamerscript::Sweeteners::JSArgumentList)
    register(Creamerscript::Sweeteners::MethodInvocation)
    register(Creamerscript::Sweeteners::MethodDefinition)
  end
end

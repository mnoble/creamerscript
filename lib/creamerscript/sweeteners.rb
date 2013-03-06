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
      sweeteners << sweetener.new
    end

    def self.each
      sweeteners.each { |s| yield s }
    end

    def self.for(type)
      sweeteners.find { |s| s.type == type }
    end

    def self.sweeteners
      @sweeteners ||= []
    end
  end
end

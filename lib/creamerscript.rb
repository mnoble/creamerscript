module Creamerscript
  class Error < RuntimeError; end
  class NotImplementedError < Error; end
end

require "active_support/inflector"
require "creamerscript/compiler"
require "creamerscript/sweeteners"


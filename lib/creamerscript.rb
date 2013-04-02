require "treetop"
require "active_support/all"
Treetop.load "./lib/creamerscript/creamerscript.treetop"

require "creamerscript/syntax_nodes"
require "creamerscript/nodes"
require "creamerscript/ast"
require "creamerscript/parser"
require "creamerscript/compiler"


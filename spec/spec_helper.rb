require "debugger"
require "creamerscript"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

RSpec::Matchers.define :compile_to do |expected|
  match do |actual|
    @compiled = compile(parse(actual))
    @compiled == expected
  end

  failure_message_for_should do |actual|
    %(expected: "#{expected}"\n  actual: "#{@compiled}")
  end

  def compile(ast)
    Creamerscript::Compiler.new.compile(ast)
  end

  def parse(code)
    Creamerscript::Parser.new.parse(code)
  end
end


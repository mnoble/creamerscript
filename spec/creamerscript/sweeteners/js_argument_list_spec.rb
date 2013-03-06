require "spec_helper"

describe Creamerscript::Sweeteners::JSArgumentList do
  let!(:sweetener) { described_class.new }

  def substitution(source)
    source.tap { sweetener.substitute(source) }
  end

  it "substitutes a normal comma seperated list of arguments" do
    substitution("(this foo:arg1, arg2, arg3)").should == "(this foo:_____CREAMER_JS_ARGUMENT_LIST_0_____)"
  end
end

require "spec_helper"

describe Creamerscript::Sweeteners::JSArgumentList do
  let!(:sweetener) { described_class.new }

  def substitution(source)
    source.tap { sweetener.tokenize(source) }
  end

  it "tokenizes a normal comma seperated list of arguments" do
    substitution("(this foo:arg1, arg2, arg3)").should == "(this foo:_____CREAMER_JS_ARGUMENT_LIST_0_____)"
  end

  it "tokenizes a list of arguments who's subject is an invocation" do
    substitution("((player find:_____CREAMER_STRING_0_____) attr:_____CREAMER_STRING_1_____, _____CREAMER_PROPERTY_INVOCATION_0_____)")
      .should == "((player find:_____CREAMER_STRING_0_____) attr:_____CREAMER_JS_ARGUMENT_LIST_0_____)"
  end
end

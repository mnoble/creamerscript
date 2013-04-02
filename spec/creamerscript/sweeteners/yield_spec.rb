require "spec_helper"

describe Creamerscript::Sweeteners::Yield do
  let!(:sweetener) { described_class.new }

  def _yield(source)
    sweetener.stub(:substitutions).and_return({ 0 => source })
    sweetener.call(0)
    sweetener
  end

  def substitution(source)
    source.tap { sweetener.tokenize(source) }
  end

  it "parses a single object to yield" do
    _yield("yield foo").arguments.should == "foo"
  end

  it "parses multiple objects to yield" do
    _yield("yield foo, bar").arguments.should == "foo, bar"
  end
end

require "spec_helper"

describe Creamerscript::Sweeteners::MethodDefinition do
  let!(:sweetener) { described_class.new }

  def definition(source)
    sweetener.stub(:substitutions).and_return({ 0 => source })
    sweetener.call(0)
    sweetener
  end

  def substitution(source)
    source.tap { sweetener.tokenize(source) }
  end

  it "tokenizes method definitions" do
    substitution("def foo:bar").should == "_____CREAMER_METHOD_DEFINITION_0_____"
  end

  it "parses out the method name" do
    definition("def do:stuff for:ever and:then report:back").method_name.should == "do_for_and_report"
  end

  it "parses out the arguments" do
    definition("def do:stuff for:ever and:then report:back").arguments.should == "stuff, ever, then, back"
  end

  it "converts to CoffeeScript" do
    definition("def do:stuff for:ever").to_coffee.should == "do_for: (stuff, ever) =>"
  end

  it "converts a method with no arguments to CoffeeScript" do
    definition("def zap").to_coffee.should == "zap: =>"
  end

  it "converts a constructor to CoffeeScript" do
    definition("def constructor:stuff with:things").to_coffee.should == "constructor: (stuff, things) ->"
  end

  it "specifies that the method can take a block" do
    definition("def foo:bar &block").arguments.should == "bar, block"
  end
end

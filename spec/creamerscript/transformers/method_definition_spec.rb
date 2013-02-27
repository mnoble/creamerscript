require "spec_helper"

describe Creamerscript::Transformers::MethodDefinition, :pending do
  it "parses out the method name" do
    definition = Creamerscript::MethodDefinition.new "def do:stuff for:ever and:then report:back"
    definition.method_name.should == "do_for_and_report"
  end

  it "parses out the arguments" do
    definition = Creamerscript::Transformers::MethodDefinition.new "def do:stuff for:ever and:then report:back"
    definition.arguments.should == "stuff, ever, then, back"
  end
end
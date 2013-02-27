require "spec_helper"

describe Creamerscript::Transformers::PropertyInvocation do
  it "parses out the subject" do
    invocation = Creamerscript::Transformers::PropertyInvocation.new "(this foo)"
    invocation.subject.should == "this"
  end

  it "parses out the property name" do
    invocation = Creamerscript::Transformers::PropertyInvocation.new "(this foo)"
    invocation.property_name.should == "foo"
  end
end

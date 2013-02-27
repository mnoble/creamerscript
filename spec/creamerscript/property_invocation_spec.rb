require "spec_helper"

describe Creamerscript::PropertyInvocation do
  it "parses out the subject" do
    invocation = Creamerscript::PropertyInvocation.new "(this foo)"
    invocation.subject.should == "this"
  end

  it "parses out the property name" do
    invocation = Creamerscript::PropertyInvocation.new "(this foo)"
    invocation.property_name.should == "foo"
  end
end

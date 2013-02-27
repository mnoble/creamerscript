require "creamerscript/method_invocation"

describe Creamerscript::MethodInvocation do
  it "parses out the subject" do
    invocation = Creamerscript::MethodInvocation.new "(this foo:bar)"
    invocation.subject.should == "this"
  end

  it "parses out the method name based on Signature Keys" do
    invocation = Creamerscript::MethodInvocation.new "(this foo:bar and:baz with:barf)"
    invocation.method_name.should == "foo_and_with"
  end

  it "parses out the arguments based on Parameter Names" do
    invocation = Creamerscript::MethodInvocation.new "(this foo:bar and:baz with:barf)"
    invocation.arguments.should == "bar, baz, barf"
  end

  it "transforms itself to Coffeescript" do
    invocation = Creamerscript::MethodInvocation.new "(this foo:bar and:baz with:barf)"
    invocation.to_coffee.should == "this.foo_and_with(bar, baz, barf)"
  end
end

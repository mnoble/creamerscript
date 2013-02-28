require "spec_helper"

describe Creamerscript::Transformers::MethodInvocation do
  def invocation(source)
    Creamerscript::Transformers::MethodInvocation.new(source)
  end

  it "parses out the subject" do
    invocation("(this foo:bar)").subject.should == "this"
  end

  it "parses out the method name based on Signature Keys" do
    invocation("(this foo:bar and:baz with:barf)").method_name.should == "foo_and_with"
  end

  it "parses out the arguments based on Parameter Names" do
    invocation("(this foo:bar and:baz with:barf)").arguments.should == "bar, baz, barf"
  end

  it "parses out the argument list when it's a normal JavaScript list" do
    invocation("(this foo:_____CREAMER_JS_ARGUMENT_LIST_0_____)").arguments.should == "_____CREAMER_JS_ARGUMENT_LIST_0_____"
  end

  it "transforms itself to Coffeescript" do
    invocation("(this foo:bar and:baz with:barf)").to_coffee.should == "this.foo_and_with(bar, baz, barf)"
  end

  it "transforms constructor calls" do
    invocation("(Date new)").to_coffee.should == "new Date()"
  end
end

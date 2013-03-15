require "spec_helper"

describe Creamerscript::Sweeteners::MethodInvocation do
  let!(:sweetener) { described_class.new }

  def invocation(source)
    sweetener.substitutions = { 0 => source }
    sweetener.call(0)
    sweetener
  end

  def substitution(source)
    source.tap { sweetener.substitute(source) }
  end

  it "substitutes nested invocations depth-first" do
    sweetener.substitute("(this foo:(bar baz:))")
    sweetener.substitutions[0].should == "(bar baz:)"
  end

  it "substitutes deeply nested invocations depth-first" do
    sweetener.substitute("(this foo:(bar baz:(beep boop:)))")
    sweetener.substitutions[0].should == "(beep boop:)"
  end

  it "substitutes deeply nested, multi-line, invocations depth-first" do
    source = %{
      (this foo:bar
            baz:(beep boop:ping
                      ding:(dong ditch:)))

      (this spark:(mark bark:(tark lark:))) }

    sweetener.substitute(source)
    sweetener.substitutions[0].should == "(dong ditch:)"
    sweetener.substitutions[1].should == "(tark lark:)"
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
    invocation("(Date new:)").to_coffee.should == "new Date()"
  end

  it "transforms constructor calls with multiple parameters" do
    invocation("(Date new:stuff with:thing)").to_coffee.should == "new Date(stuff, thing)"
  end
end

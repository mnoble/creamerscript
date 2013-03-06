require "spec_helper"

describe Creamerscript::Sweeteners::PropertyInvocation do
  let!(:sweetener) { described_class.new }

  def invocation(source)
    sweetener.stub(:substitutions).and_return({ 0 => source })
    sweetener.call(0)
    sweetener
  end

  def substitution(source)
    source.tap { sweetener.substitute(source) }
  end

  it "substitutes property invocations" do
    substitution("(this selector)").should == "_____CREAMER_PROPERTY_INVOCATION_0_____"
  end

  it "parses out the subject" do
    invocation("(this foo)").subject.should == "this"
  end

  it "parses out the property name" do
    invocation("(this foo)").property_name.should == "foo"
  end
end

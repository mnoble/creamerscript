require "spec_helper"

describe Creamerscript::Sweeteners::Object do
  let!(:sweetener) { described_class.new }

  def substitution(source)
    source.tap { sweetener.substitute(source) }
  end

  it "substitutes an object" do
    substitution("{a:1, b:2}").should == "_____CREAMER_OBJECT_0_____"
  end

  it "substitutes a nested object" do
    sweetener.substitute("{a:1, b:{c:2, d:3}}")
    sweetener.substitutions[0].should == "{c:2, d:3}"
  end

  it "substitutes many objects" do
    substitution("{a:1} {b:2} {c:3}").should == "_____CREAMER_OBJECT_0_____ _____CREAMER_OBJECT_1_____ _____CREAMER_OBJECT_2_____"
  end
end

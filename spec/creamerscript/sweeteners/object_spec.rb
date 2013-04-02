require "spec_helper"

describe Creamerscript::Sweeteners::Object do
  let!(:sweetener) { described_class.new }

  def substitution(source)
    source.tap { sweetener.tokenize(source) }
  end

  it "tokenizes an object" do
    substitution("{a:1, b:2}").should == "_____CREAMER_OBJECT_0_____"
  end

  it "tokenizes a nested object" do
    sweetener.tokenize("{a:1, b:{c:2, d:3}}")
    sweetener.substitutions[0].should == "{c:2, d:3}"
  end

  it "tokenizes many objects" do
    substitution("{a:1} {b:2} {c:3}").should == "_____CREAMER_OBJECT_0_____ _____CREAMER_OBJECT_1_____ _____CREAMER_OBJECT_2_____"
  end
end

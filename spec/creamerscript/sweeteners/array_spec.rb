require "spec_helper"

describe Creamerscript::Sweeteners::Array do
  let!(:sweetener) { described_class.new }

  def substitution(source)
    source.tap { sweetener.tokenize(source) }
  end

  it "tokenizes an array" do
    substitution("[1, 2, 3]").should == "_____CREAMER_ARRAY_0_____"
  end

  it "tokenizes a nested array" do
    sweetener.tokenize("[1, [2, 3], 4]")
    sweetener.substitutions[0].should == "[2, 3]"
  end

  it "tokenizes many arrays" do
    substitution("[1, 2, 3] [4, 5] [6, 7, 8]").should == "_____CREAMER_ARRAY_0_____ _____CREAMER_ARRAY_1_____ _____CREAMER_ARRAY_2_____"
  end

  it "stores the content of each array" do
    sweetener.tokenize("[1, 2, 3] [4, 5] [6, 7, 8]")
    sweetener.substitutions[2].should == "[6, 7, 8]"
  end

  it "stores the content of nested arrays" do
    sweetener.tokenize(sweetener.tokenize("[1, [2, 3], 4]"))
    sweetener.substitutions[0].should == "[2, 3]"
    sweetener.substitutions[1].should == "[1, _____CREAMER_ARRAY_0_____, 4]"
  end
end

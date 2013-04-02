require "spec_helper"

describe Creamerscript::Sweeteners::String do
  let!(:sweetener) { described_class.new }

  def substitution(source)
    source.tap { sweetener.tokenize(source) }
  end

  it "tokenizes a string" do
    substitution('"hello"').should == "_____CREAMER_STRING_0_____"
  end

  it "tokenizes a string containing an escaped quote" do
    substitution('"MOG \"Its you!\""').should == "_____CREAMER_STRING_0_____"
  end

  it "tokenizes many strings" do
    substitution('"hey" "there guy" "whats up"').should == "_____CREAMER_STRING_0_____ _____CREAMER_STRING_1_____ _____CREAMER_STRING_2_____"
  end

  it "stores the content of each string" do
    sweetener.tokenize('"hey" "there guy" "whats up"')
    sweetener.substitutions[1].should == '"there guy"'
  end

  it "stores the content of each string containing escaped quotes" do
    sweetener.tokenize('"hey" "there \"guy\"" "whats up"')
    sweetener.substitutions[1].should == '"there \"guy\""'
  end
end

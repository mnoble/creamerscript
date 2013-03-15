require "spec_helper"

describe Creamerscript::Sweeteners::Block do
  let!(:sweetener) { described_class.new }

  def block(source)
    sweetener.substitutions = { 0 => source }
    sweetener.call(0)
    sweetener
  end

  def substitution(source)
    source.tap { sweetener.substitute(source) }
  end

  it "substitutes a single-line block" do
    substitution("(this map) { n | n + 1 }").should == "(this map:_____CREAMER_BLOCK_0_____)"
  end

  it "substitutes a multi-line block" do
    substitution("(this map) { n |
      n + 1
    }").should == "(this map:_____CREAMER_BLOCK_0_____)"
  end

  it "has arguments" do
    block("(this compare) { a b | a <=> b }").arguments.should == ["a", "b"]
  end

  it "has a body when arguments are included" do
    block("(this compare) { a b | a <=> b }").body.should == " a <=> b"
  end

  it "has a body when with no arguments" do
    block("(1 times) { true }").body.should == " true"
  end

  it "transforms a single-line block into Coffeescript" do
    block("(this compare) { a b | a == b }").to_coffee.should == "(a, b) -> a == b"
  end

  it "transforms a multi-line block into Coffeescript" do
    block("(this compare) { a b |
      a += 1
      a == b 
    }").to_coffee.should == "(a, b) ->
      a += 1
      a == b"
  end
end

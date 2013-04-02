require "spec_helper"

describe "Function Calls" do
  it "calls a function with no arguments" do
    "(hello world)".should compile_to "hello.world()"
  end

  it "calls a function with one argument" do
    "(person set_age:26)".should compile_to "person.set_age(26)"
  end

  it "calls a function with two arguments" do
    "(person set_age:26 and_weight:220)".should compile_to "person.set_age_and_weight(26, 220)"
  end
end

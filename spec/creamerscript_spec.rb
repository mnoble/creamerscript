require_relative "../creamerscript"
require "debugger"

module Fixture
  extend self

  def load(name)
    @fixtures ||= {}
    @fixtures[name] ||= load_fixture(name)
  end

  def load_fixture(name)
    Hash[*File.read(File.dirname(__FILE__) + "/fixtures.txt").split(/@@(.+)$/).reject(&:empty?)][name]
  end
end

describe Creamerscript::MethodInvocation do
  def invocation(fixture)
    Creamerscript::MethodInvocation.new(Fixture.load(fixture))
  end

  it "finds the subject the method is being called on" do
    invocation("cs-invocation").subject.should == "Date"
  end

  it "finds the method name to call" do
    invocation("cs-invocation").method_name.should == "init_with_year_and_month_and_day"
  end

  it "has value arguments only" do
    invocation("js-invocation").should be_value_arguments_only
  end

  it "finds a JavaScript method name" do
    invocation("js-invocation").method_name.should == "each"
  end

  it "finds the arguments" do
    invocation("cs-invocation").arguments.should == "1986, 6, 20"
  end

  it "finds regular JavaScript arguments" do
    invocation("js-invocation").arguments.should == "[1, 2, 3], do_thing"
  end

  it "transforms to a Coffeescript method invocation" do
    invocation("cs-invocation").to_cs.should == "Date.init_with_year_and_month_and_day(1986, 6, 20)"
  end

  it "transforms a method invocation with no arguments" do
    invocation("no-args-invocation").to_cs.should == "this.foo()"
  end

  it "transforms a multi-line method invocation" do
    invocation("multi-line-invocation").to_cs.should == "Date.init_with_year_and_month_and_day(1986, 6, 20)"
  end

  it "transforms a method invocation with a newline after the subject" do
    invocation("newline-after-subject-invocation").to_cs.should == "Date.init_with_year_and_month_and_day(1986, 6, 20)"
  end
end

describe Creamerscript::MethodSignature do
  def signature(fixture)
    Creamerscript::MethodSignature.new(Fixture.load(fixture))
  end

  it "determines the method name" do
    signature("cs-signature").method_name.should == "init_with_year_and_month_and_day"
  end

  it "determines the method arguments" do
    signature("cs-signature").arguments.should == "year, month, day"
  end

  it "transforms to a Coffeescript method signature" do
    signature("cs-signature").to_cs.should == "init_with_year_and_month_and_day: (year, month, day) =>"
  end

  it "transforms a multi-line method signature" do
    signature("multi-line-signature").to_cs.should == "init_with_year_and_month_and_day: (year, month, day) =>"
  end
end

describe Creamerscript::Compiler do
  def compiled(fixture)
    Creamerscript::Compiler.compile(Fixture.load(fixture))
  end

  it "transforms method invocations" do
    compiled("full-class").should == <<-CODE

class Date
  init_with_year_and_month_and_day: (year, month, day) =>
    @year  = year
    @month = month
    @day   = day

  days_before: =>
    Date.format_with(@day, "\#{@month} %d")

  days_after: =>
    this.after(@month, this.year(@year))

CODE
  end
end




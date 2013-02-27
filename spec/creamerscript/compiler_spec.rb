require "spec_helper"

describe Creamerscript::Compiler do
  let!(:compiler) { Creamerscript::Compiler.new }

  it "has a substitutor" do
    compiler.substitutor.should be_a Creamerscript::Substitutor
  end

  it "transforms an invocation substitution into a function call" do
    compiler.stub(:invocations).and_return({ 0 => "(this foo:bar baz:zap)" })
    compiler.transform_invocation("_____CREAMER_INVOCATION_0_____").should == "this.foo_baz(bar, zap)"
  end

  it "transforms a property substitution" do
    compiler.stub(:properties).and_return({ 0 => "(this foo)" })
    compiler.transform_property("_____CREAMER_PROPERTY_0_____").should == "this.foo"
  end

  it "transforms an array substitution" do
    compiler.stub(:arrays).and_return({ 0 => "[1, 2, 3]" })
    compiler.transform_array("_____CREAMER_ARRAY_0_____").should == "[1, 2, 3]"
  end

  it "transforms an array substitution" do
    compiler.stub(:arrays).and_return({ 0 => "[1, 2, 3]" })
    compiler.transform_array("_____CREAMER_ARRAY_0_____").should == "[1, 2, 3]"
  end

  it "transforms a string substitution" do
    compiler.stub(:strings).and_return({ 0 => '"MEOW"' })
    compiler.transform_string("_____CREAMER_STRING_0_____").should == '"MEOW"'
  end

  it "transforms an object substitution" do
    compiler.stub(:objects).and_return({ 0 => "{a:1, b:2}" })
    compiler.transform_object("_____CREAMER_OBJECT_0_____").should == "{a:1, b:2}"
  end

  it "transforms all substitutions" do
    source = %{
      def foo
        (this bar:baz beep:{a:1})
        (this alert:"MOG")
        return true

      def zap
        a = (1 + 1)
        (console log:a)
        (connection send_async_request:(Request create:)
                                 queue:"main_queue"
                    completion_handler:(this complete))
    }

    coffee = compiler.compile(source)

    coffee.should == %{
      def foo
        this.bar_beep(baz, {a:1})
        this.alert("MOG")
        return true

      def zap
        a = (1 + 1)
        console.log(a)
        connection.send_async_request_queue_completion_handler(Request.create(), "main_queue", this.complete)
    }
  end
end

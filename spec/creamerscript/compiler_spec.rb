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

  it "transforms a JavaScript argument list substitution" do
    compiler.stub(:js_argument_lists).and_return({ 0 => "arg1, arg2, arg3" })
    compiler.transform_js_argument_list("_____CREAMER_JS_ARGUMENT_LIST_0_____").should == "arg1, arg2, arg3"
  end

  it "transforms a string substitution" do
    compiler.stub(:strings).and_return({ 0 => '"MEOW"' })
    compiler.transform_string("_____CREAMER_STRING_0_____").should == '"MEOW"'
  end

  it "transforms an object substitution" do
    compiler.stub(:objects).and_return({ 0 => "{a:1, b:2}" })
    compiler.transform_object("_____CREAMER_OBJECT_0_____").should == "{a:1, b:2}"
  end

  it "transforms a method definition substitution" do
    compiler.stub(:definitions).and_return({ 0 => "def foo:bar baz:zap" })
    compiler.transform_definition("_____CREAMER_DEFINITION_0_____").should == "foo_baz: (bar, zap) =>"
  end

  it "transforms all substitutions" do
    source = %{
      def foo:bar baz:zap
        (this bar:baz beep:{a:1})
        (this alert:"MOG")
        return (_ all:[true], (this all_iter), this)

      def zap
        a = (1 + 1)
        (console log:a)
        (connection send_async_request:(Request new:)
                                 queue:"main_queue"
                    completion_handler:(this complete))
    }

    coffee = compiler.compile(source)

    coffee.should == %{
      foo_baz: (bar, zap) =>
        this.bar_beep(baz, {a:1})
        this.alert("MOG")
        return _.all([true], this.all_iter, this)

      zap: =>
        a = (1 + 1)
        console.log(a)
        connection.send_async_request_queue_completion_handler(new Request(), "main_queue", this.complete)
    }
  end
end


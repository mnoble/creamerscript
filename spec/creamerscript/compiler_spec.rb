require "spec_helper"

describe Creamerscript::Compiler do
  it "transforms all substitutions" do
    Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::String)
    Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::Array)
    Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::Object)
    Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::PropertyInvocation)
    Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::JSArgumentList)
    Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::MethodInvocation)
    Creamerscript::Sweeteners.register(Creamerscript::Sweeteners::MethodDefinition)

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

    Creamerscript::Compiler.new(source).compile.should == %{
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


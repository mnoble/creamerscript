require "spec_helper"

describe Creamerscript::Compiler do
  it "transforms all substitutions" do
    source = %{
      def foo:bar baz:zap
        (this bar:baz beep:{a:1})
        (this alert:"MOG")
        return (_ all:[true], this.all_iter, this)

      def zap
        a = (1 + 1)
        (console log:a)
        (connection send_async_request:(Request new)
                                 queue:"main_queue"
                    completion_handler:this.complete)

      (things map) { thing | [1, thing] }

      (people map) { p | p.name }
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

      things.map((thing) -> [1, thing])

      people.map((p) -> p.name)
    }
  end
end


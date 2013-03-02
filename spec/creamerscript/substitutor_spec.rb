require "spec_helper"

describe Creamerscript::Substitutor do
  let!(:substitutor) { Creamerscript::Substitutor.new }

  describe "Strings" do
    it "substitutes a string" do
      substitutor.sub_string('"hello"').should == "_____CREAMER_STRING_0_____"
    end

    it "substitutes a string containing an escaped quote" do
      substitutor.sub_string('"MOG \"Its you!\""').should == "_____CREAMER_STRING_0_____"
    end

    it "substitutes many strings" do
      substitutor.sub_string('"hey" "there guy" "whats up"').should == "_____CREAMER_STRING_0_____ _____CREAMER_STRING_1_____ _____CREAMER_STRING_2_____"
    end

    it "stores the content of each string" do
      substitutor.sub_string('"hey" "there guy" "whats up"')
      substitutor.strings[1].should == '"there guy"'
    end

    it "stores the content of each string containing escaped quotes" do
      substitutor.sub_string('"hey" "there \"guy\"" "whats up"')
      substitutor.strings[1].should == '"there \"guy\""'
    end
  end

  describe "Arrays" do
    it "substitutes an array" do
      substitutor.sub_array("[1, 2, 3]").should == "_____CREAMER_ARRAY_0_____"
    end

    it "substitutes a nested array" do
      substitutor.sub_array("[1, [2, 3], 4]").should == "[1, _____CREAMER_ARRAY_0_____, 4]"
    end

    it "substitutes many arrays" do
      substitutor.sub_array("[1, 2, 3] [4, 5] [6, 7, 8]").should == "_____CREAMER_ARRAY_0_____ _____CREAMER_ARRAY_1_____ _____CREAMER_ARRAY_2_____"
    end

    it "stores the content of each array" do
      substitutor.sub_array("[1, 2, 3] [4, 5] [6, 7, 8]")
      substitutor.arrays[2].should == "[6, 7, 8]"
    end

    it "stores the content of nested arrays" do
      substitutor.sub_array(substitutor.sub_array("[1, [2, 3], 4]"))
      substitutor.arrays[0].should == "[2, 3]"
      substitutor.arrays[1].should == "[1, _____CREAMER_ARRAY_0_____, 4]"
    end
  end

  describe "Objects" do
    it "substitutes an object" do
      substitutor.sub_object("{a:1, b:2}").should == "_____CREAMER_OBJECT_0_____"
    end

    it "substitutes a nested object" do
      substitutor.sub_object("{a:1, b:{c:2, d:3}}").should == "{a:1, b:_____CREAMER_OBJECT_0_____}"
    end

    it "substitutes many objects" do
      substitutor.sub_object("{a:1} {b:2} {c:3}").should == "_____CREAMER_OBJECT_0_____ _____CREAMER_OBJECT_1_____ _____CREAMER_OBJECT_2_____"
    end

    it "stores the content of each object" do
      substitutor.sub_object("{a:1} {b:2} {c:3}")
      substitutor.objects[2].should == "{c:3}"
    end

    it "stores the content of nested objects" do
      substitutor.sub_object(substitutor.sub_object("{a:1, b:{c:2, d:3}}"))
      substitutor.objects[0].should == "{c:2, d:3}"
      substitutor.objects[1].should == "{a:1, b:_____CREAMER_OBJECT_0_____}"
    end
  end

  describe "CreamerScript Invocations" do
    it "substitutes nested invocations depth-first" do
      substitutor.sub_invocations("(this foo:(bar baz:))").should == "(this foo:_____CREAMER_INVOCATION_0_____)"
    end

    it "substitutes deeply nested invocations depth-first" do
      substitutor.sub_invocations("(this foo:(bar baz:(beep boop:)))").should == "(this foo:(bar baz:_____CREAMER_INVOCATION_0_____))"
    end

    it "substitutes deeply nested, multi-line, invocations depth-first" do
      source = %{
        (this foo:bar
              baz:(beep boop:ping
                        ding:(dong ditch:)))

        (this spark:(mark bark:(tark lark:))) }

      substitutor.sub_invocations(source)

      source.should == %{
        (this foo:bar
              baz:(beep boop:ping
                        ding:_____CREAMER_INVOCATION_0_____))

        (this spark:(mark bark:_____CREAMER_INVOCATION_1_____)) }
    end
  end

  describe "JavaScript Invocations" do
    it "substitutes a normal comma seperated list of arguments" do
      substitutor.sub_js_argument_list("(this foo:arg1, arg2, arg3)").should == "(this foo:_____CREAMER_JS_ARGUMENT_LIST_0_____)"
    end
  end

  describe "Properties" do
    it "substitutes property invocations" do
      substitutor.sub_invocations("(this selector)").should == "_____CREAMER_PROPERTY_0_____"
    end
  end

  describe "Method Definitions" do
    it "substitutes method definitions" do
      substitutor.sub_definitions("def foo:bar").should == "_____CREAMER_DEFINITION_0_____"
    end
  end

  it "stores the contents of all occurences of strings, arrays, objects and invocations" do
    source = %{
      def foo:bar beep:boop
        (this map:[1, [2, (a get)], 3] and_print:"MAPPED AND JUNK" until:(beep boop:(bop mop:)) so_that:[1, 2] will_become:{a:1, b:2})'
    }

    substitutor.sub!(source)

    substitutor.strings[0].should == '"MAPPED AND JUNK"'

    substitutor.arrays[0].should == "[2, _____CREAMER_PROPERTY_0_____]"
    substitutor.arrays[1].should == "[1, 2]"
    substitutor.arrays[2].should == "[1, _____CREAMER_ARRAY_0_____, 3]"

    substitutor.objects[0].should == "{a:1, b:2}"

    substitutor.properties[0].should == "(a get)"

    substitutor.invocations[0].should == "(bop mop:)"
    substitutor.invocations[1].should == "(beep boop:_____CREAMER_INVOCATION_0_____)"
    substitutor.invocations[2].should == "(this map:_____CREAMER_ARRAY_2_____ and_print:_____CREAMER_STRING_0_____ until:_____CREAMER_INVOCATION_1_____ so_that:_____CREAMER_ARRAY_1_____ will_become:_____CREAMER_OBJECT_0_____)"

    substitutor.definitions[0].should == "def foo:bar beep:boop"
  end
end

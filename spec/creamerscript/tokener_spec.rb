require "creamerscript/tokener"

describe Creamerscript::Tokener do
  subject(:tokener) { Creamerscript::Tokener.new }

  it "substitutes an integer" do
    tokener.sub_integers("1").should == "_____CREAMER_INTEGER_0_____"
  end

  it "substitutes many integers" do
    tokener.sub_integers("1 3 6").should == "_____CREAMER_INTEGER_0_____ _____CREAMER_INTEGER_1_____ _____CREAMER_INTEGER_2_____"
  end

  it "stores the content of each integer" do
    tokener.sub_integers("1 3 6")
    tokener.integers[1].should == "3"
  end

  it "substitutes a float" do
    tokener.sub_float("1.98").should == "_____CREAMER_FLOAT_0_____"
  end

  it "substitutes many floats" do
    tokener.sub_float("1.5 0.8 1.33345").should == "_____CREAMER_FLOAT_0_____ _____CREAMER_FLOAT_1_____ _____CREAMER_FLOAT_2_____"
  end

  it "stores the content of each integer" do
    tokener.sub_float("1.5 0.8 1.33345")
    tokener.floats[2].should == "1.33345"
  end

  it "substitutes a string" do
    tokener.sub_string('"hello"').should == "_____CREAMER_STRING_0_____"
  end

  it "substitutes a string containing an escaped quote" do
    tokener.sub_string('"MOG \"Its you!\""').should == "_____CREAMER_STRING_0_____"
  end

  it "substitutes many strings" do
    tokener.sub_string('"hey" "there guy" "whats up"').should == "_____CREAMER_STRING_0_____ _____CREAMER_STRING_1_____ _____CREAMER_STRING_2_____"
  end

  it "stores the content of each string" do
    tokener.sub_string('"hey" "there guy" "whats up"')
    tokener.strings[1].should == '"there guy"'
  end

  it "stores the content of each string containing escaped quotes" do
    tokener.sub_string('"hey" "there \"guy\"" "whats up"')
    tokener.strings[1].should == '"there \"guy\""'
  end

  it "substitutes an array" do
    tokener.sub_array("[1, 2, 3]").should == "_____CREAMER_ARRAY_0_____"
  end

  it "substitutes a nested array" do
    tokener.sub_array("[1, [2, 3], 4]").should == "[1, _____CREAMER_ARRAY_0_____, 4]"
  end

  it "substitutes many arrays" do
    tokener.sub_array("[1, 2, 3] [4, 5] [6, 7, 8]").should == "_____CREAMER_ARRAY_0_____ _____CREAMER_ARRAY_1_____ _____CREAMER_ARRAY_2_____"
  end

  it "stores the content of each array" do
    tokener.sub_array("[1, 2, 3] [4, 5] [6, 7, 8]")
    tokener.arrays[2].should == "[6, 7, 8]"
  end

  it "stores the content of nested arrays" do
    tokener.sub_array(tokener.sub_array("[1, [2, 3], 4]"))
    tokener.arrays[0].should == "[2, 3]"
    tokener.arrays[1].should == "[1, _____CREAMER_ARRAY_0_____, 4]"
  end

  it "substitutes an object" do
    tokener.sub_object("{a:1, b:2}").should == "_____CREAMER_OBJECT_0_____"
  end

  it "substitutes a nested object" do
    tokener.sub_object("{a:1, b:{c:2, d:3}}").should == "{a:1, b:_____CREAMER_OBJECT_0_____}"
  end

  it "substitutes many objects" do
    tokener.sub_object("{a:1} {b:2} {c:3}").should == "_____CREAMER_OBJECT_0_____ _____CREAMER_OBJECT_1_____ _____CREAMER_OBJECT_2_____"
  end

  it "stores the content of each object" do
    tokener.sub_object("{a:1} {b:2} {c:3}")
    tokener.objects[2].should == "{c:3}"
  end

  it "stores the content of nested objects" do
    tokener.sub_object(tokener.sub_object("{a:1, b:{c:2, d:3}}"))
    tokener.objects[0].should == "{c:2, d:3}"
    tokener.objects[1].should == "{a:1, b:_____CREAMER_OBJECT_0_____}"
  end
end

require "spec_helper"
require "pathname"

describe Creamerscript::Compiler do
  it"compiles correctly" do
    spec_root = Pathname.new(__FILE__).join("../../").expand_path
    creamers  = Pathname.glob(spec_root.join("files/**/*.creamer"))

    creamers.each do |c|
      compiler = Creamerscript::Compiler.new(c.read)
      compiler.compile.should == c.sub_ext(".coffee").read
    end
  end
end


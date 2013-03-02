require "ostruct"
require "optparse"
require "pathname"

module Creamerscript
  class CLI
    attr_accessor :compiler, :options, :files

    def initialize(args)
      @compiler = Compiler.new
      @options  = OpenStruct.new(run: true)
      @files    = Pathname.glob(args.pop)
      parse(args)
    end

    def parse(args)
      OptionParser.new do |opts|
        opts.banner = "Usage: creamer [options] path/to/script.creamer"

        opts.separator ""
        opts.separator "If called without options, `creamer` will run your script"

        opts.on("-c", "--compile", "Compile to CoffeeScript and save as .coffee files") do |*|
          options.run = false
          options.compile = true
        end

        opts.on("-o", "--output", String, "Set the directory to save compiled CreamerScript") do |dir|
          options.run = false
          options.output = dir
        end
      end.parse!(args)
    end

    def run
      files.each do |file|
        if options.compile
          directory = options.output && Patname.new(options.output) || file.dirname
          output    = directory.join(file.basename.sub_ext(".coffee"))
          output.open("w+") { |f| f << compiler.compile(file.read) }
        else
          puts compiler.compile(file.read)
        end
      end
    end
  end
end

module Creamerscript
  STRING     = Regexp.union(/"[^"]+"/, /'[^']+'/)
  BOOLEAN    = /true|false/
  INTEGER    = /\d+/
  FLOAT      = /#{INTEGER}\.#{INTEGER}/
  SYMBOL     = /[A-Za-z_\$@][A-Za-z0-9_\.]*/
  VALUE      = Regexp.union(STRING, BOOLEAN, FLOAT, INTEGER, SYMBOL)
  KEYVALUE   = /\s*#{SYMBOL}:#{VALUE}/
  KVPAIRS    = /(?:#{KEYVALUE})+/
  INVOCATION = /\(#{SYMBOL} #{SYMBOL}(?::#{VALUE})*(?:\s+#{KVPAIRS})*\)/
  SIGNATURE  = /def #{SYMBOL}(?::#{VALUE})*(?:\s+#{KVPAIRS})*/

  module Compiler
    extend self

    def compile(code)
      compile_signatures!(code)
      compile_invocations!(code)
      code
    end

    def compile_signatures!(code)
      code.gsub!(SIGNATURE)  { |m| MethodSignature.new(m).to_cs }
    end

    def compile_invocations!(code)
      code.gsub!(INVOCATION) { |m| MethodInvocation.new(m).to_cs } while code =~ INVOCATION
    end
  end

  class MethodInvocation
    def initialize(invocation)
      @invocation = invocation
    end

    def to_cs
      "#{subject}.#{method_name}(#{arguments})"
    end

    # Callee of a method invocation.
    #
    # First symbol before a space, with the opening
    # parenthesis removed.
    #
    def subject
      invocation.split.first[1..-1]
    end

    # Method name to call.
    #
    # Creamerscript method names comprise of all keys from the 
    # argument list,joined with an underscore. There is no static 
    # method name like in most languages, Creamerscript takes the 
    # same approach as Objective-C.
    #
    # Example
    #
    #   (Time year:1986 month:6 day:20)
    #   # => year_month_day
    #
    # Creamerscript supports calling of regular JavaScript methods too.
    # This means foregoing the argument descriptions and only passing
    # values.
    #
    # Example
    #
    #   (_ where: people, { name: "Steve" })
    #   # => where
    #
    def method_name
      (value_arguments_only? || has_no_arguments?) ? bare_method_name : method_name_from_arguments
    end

    def has_no_arguments?
      !invocation.include?(":")
    end

    def method_name_from_arguments
      invocation.scan(KEYVALUE).map { |kv| kv.strip.split(":").first }.join("_")
    end

    def bare_method_name
      invocation.scan(/\(#{SYMBOL} (#{SYMBOL})/)[0][0]
    end

    # Arguments of a method invocation.
    #
    # For Creamerscript methods, it takes the same approach as +method+,
    # except using the value of each key-value pair to create a list
    # of arguments.
    #
    # Example
    #
    #   (Time year:1986 month:6 day:20)
    #   # => 1986, 6, 20
    #
    # For traditional JavaScript method invocations, the argument list
    # is everything on the right-hand side of the :
    #
    # Example
    #
    #   (_ where: people, { name: "Steve" })
    #   # => people, { name: "Steve" }
    #
    def arguments
      value_arguments_only? ? arguments_from_values : arguments_from_key_value_pairs
    end

    # Parses traditional JavaScript argument from a Creamerscript
    # method invocation.
    #
    def arguments_from_values
      invocation.scan(/:(.+)\)/)[0][0].strip
    end

    # Parses a list of arguments when the invocation uses the
    # Creamerscript syntax.
    #
    def arguments_from_key_value_pairs
      invocation.scan(KEYVALUE).map { |kv| kv.strip.split(":").last }.join(", ")
    end

    def value_arguments_only?
      invocation.match /\(#{SYMBOL} #{SYMBOL}:[^:]+\)/
    end

    def invocation
      @invocation
    end
  end

  class MethodSignature
    def initialize(signature)
      @signature = signature
    end

    def to_cs
      "#{method_name}: #{ "(#{arguments}) " unless arguments.empty? }=>"
    end

    # Method name
    #
    # Follows the Objective-C approach where the name is actually a
    # composite of all argument descriptions.
    #
    # Example
    #
    #   def init_with_year:year and_month:month and_day:day
    #   # => init_with_year_and_month_and_day
    #
    def method_name
      has_arguments? ? method_name_with_arguments : method_name_without_arguments
    end

    def has_arguments?
      signature.include?(":")
    end

    def method_name_with_arguments
      signature.scan(KEYVALUE).map { |kv| kv.strip.split(":").first }.join("_")
    end

    def method_name_without_arguments
      signature.scan(/def (#{SYMBOL})/)[0][0]
    end

    # List of argument variables
    #
    # Values from each key-value pair are the variables used
    # to reference what has been passed in. These are like the
    # normal function parameters you're used to in Javascript.
    #
    # Example
    #
    #   def init_with_year:year and_month:month and_day:day
    #   # => year, month, day
    #
    def arguments
      signature.scan(KEYVALUE).map { |kv| kv.strip.split(":").last }.join(", ")
    end

    def signature
      @signature
    end
  end
end

if __FILE__ == $0
  puts Creamerscript::Compiler.compile(File.read(ARGV[0]))
end


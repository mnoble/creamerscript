module Creamerscript
  module Transformers
    class MethodDefinition
      attr_accessor :source

      def initialize(source)
        @source = source
      end

      def to_coffee
        arguments.empty? ? definition_without_arguments : definition_with_arguments
      end

      def definition_without_arguments
        "#{method_name}: =>"
      end

      def definition_with_arguments
        "#{method_name}: (#{arguments}) =>"
      end

      # Signature Keys are combined with an underscore to generate
      # the final method name.
      #
      # Example
      #
      #   def foo:bar baz:beep
      #   # => "foo_baz"
      #
      def method_name
        signature_keys.join("_")
      end

      # Parameter Names becomes a list of normal Coffeescript
      # function arguments.
      #
      # Example
      #
      #   def foo:bar baz:beep
      #   # => "bar, beep"
      #
      def arguments
        parameter_names.join(", ")
      end

      private

      def signature_keys
        argument_list.flatten.each_with_index.map { |arg, index| arg if index.even? }.compact
      end

      def parameter_names
        argument_list.flatten.each_with_index.map { |arg, index| arg.gsub(",", "") if index.odd? }.compact
      end

      def argument_list
        body.split.map { |arg| arg.split(":") }
      end

      def body
        source.split("def ").last
      end
    end
  end
end

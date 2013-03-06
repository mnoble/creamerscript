module Creamerscript
  module Sweeteners
    class MethodDefinition < Base
      def pattern
        /def #{SYMBOL}(?::#{SYMBOL})?(?:\s+#{SYMBOL}:#{SYMBOL})*/
      end

      def to_coffee
        if method_name =~ /^constructor/
          constructor
        else
          arguments.empty? ? definition_without_arguments : definition_with_arguments
        end
      end

      def constructor
        "constructor: (#{arguments}) ->"
      end

      def definition_without_arguments
        "#{method_name}: =>"
      end

      def definition_with_arguments
        "#{method_name}: (#{arguments}) =>"
      end

      def method_name
        signature_keys.join("_")
      end

      def arguments
        parameter_names.join(", ")
      end

      def type
        :method_definition
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

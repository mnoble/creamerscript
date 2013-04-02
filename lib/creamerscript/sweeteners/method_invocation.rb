module Creamerscript
  module Sweeteners
    class MethodInvocation < Base
      def pattern
        /\(#{SYMBOL} #{SYMBOL}[^\(\)]*\)/m
      end

      def to_coffee
        coffee = method_name =~ /^new/ ? initializer : normal_method_call
        @block = nil
        coffee
      end

      def initializer
        "new #{subject}(#{arguments})"
      end

      def normal_method_call
        "#{subject}.#{method_name}(#{arguments})"
      end

      def subject
        body.split.first
      end

      def method_name
        signature_keys.join("_")
      end

      def arguments
        (parameter_values << @block).compact.join(", ")
      end

      private

      def signature_keys
        argument_list.flatten.each_with_index.map { |arg, index| arg if index.even? }.compact
      end

      def parameter_values
        argument_list.flatten.each_with_index.map { |arg, index| arg.gsub(",", "") if index.odd? }.compact
      end

      def argument_list
        body_without_subject.map { |arg| arg.split(":") }
      end

      def body_without_subject
        body.split[1..-1]
      end

      def body
        source[1..-2].gsub(/ &block:([^\s]+)/) { @block = $1; "" }
      end
    end
  end
end

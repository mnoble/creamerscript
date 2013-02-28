module Creamerscript
  module Transformers
    class MethodInvocation
      attr_accessor :source

      def initialize(source)
        @source = source
      end

      def to_coffee
        method_name == "new" ? initializer : normal_method_call
      end

      def initializer
        "new #{subject}(#{arguments})"
      end

      def normal_method_call
        "#{subject}.#{method_name}(#{arguments})"
      end

      # The object to call the method on.
      #
      def subject
        body.split.first
      end

      # The values before each ":" are combined to define
      # which method to call. Method Definitions work in the
      # fashion.
      #
      # Example
      #
      #   (this foo:bar baz:beep)
      #   # => foo_baz
      #
      def method_name
        signature_keys.join("_")
      end

      # The values after each ":" become a normal list
      # of Coffeescript Parameters.
      #
      # Example
      #
      #   (this foo:bar baz:beep)
      #   # => "bar, beep"
      #
      def arguments
        parameter_values.join(", ")
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
        source[1..-2]
      end
    end
  end
end

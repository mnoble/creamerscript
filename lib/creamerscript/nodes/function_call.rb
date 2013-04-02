module Creamerscript
  module Nodes
    class FunctionCall < CollectionNode
      def to_coffee
        "#{subject}.#{signature}(#{arguments})"
      end

      def subject
        elements.find { |e| e.is_a? FunctionSubject }.to_coffee
      end

      def signature
      end

      def arguments
      end
    end
  end
end

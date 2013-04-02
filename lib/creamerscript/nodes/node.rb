module Creamerscript
  module Nodes
    class Node < Treetop::Runtime::SyntaxNode
      def to_a
        [name, text_value]
      end

      def name
        self.class.name.demodulize.underscore.to_sym
      end
    end

    class CollectionNode < Node
      def to_a
        [name, elements.map(&:to_a)]
      end
    end
  end
end

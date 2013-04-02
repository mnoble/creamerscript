module Creamerscript
  class AST
    attr_reader :tree

    def initialize(tree)
      @tree = tree
    end

    def root
      tree.first
    end

    def to_s
      tree.inspect
    end
  end
end

module Creamerscript
  class Parser < CreamerscriptParser
    def parse(code)
      clean(super(code)).first
    end

    def clean(node)
      return if node.elements.nil?
      node.elements.delete_if { |node| node.class == Creamerscript::SyntaxNode }
      node.elements.each { |node| clean(node) }
    end
  end
end

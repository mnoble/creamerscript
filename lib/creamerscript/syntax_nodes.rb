module Creamerscript
  class SyntaxNode < Treetop::Runtime::SyntaxNode
    def value
      text_value
    end

    def to_a
      [name, text_value]
    end

    def name
      self.class.name.demodulize.underscore.to_sym
    end
  end

  class Block < SyntaxNode
    def to_a
      elements.map { |e| e.to_a }
    end
  end

  class Expression < SyntaxNode
    def to_coffee
      elements.map(&:to_coffee)
    end

    def value
      elements[0].value
    end

    def to_a
      elements[0].to_a
    end
  end

  class Statement < SyntaxNode
    def to_coffee
      elements.map(&:to_coffee)
    end

    def value
      elements[0].value
    end

    def to_a
      elements[0].to_a
    end
  end

  class NilLiteral < SyntaxNode
  end

  class TrueLiteral < SyntaxNode
  end

  class FalseLiteral < SyntaxNode
  end

  class IntegerLiteral < SyntaxNode
  end

  class FloatLiteral < SyntaxNode
  end

  class StringLiteral < SyntaxNode
    def to_coffee
      text_value
    end
  end

  class Identifier < SyntaxNode
    def to_coffee
      text_value
    end
  end

  class HashLiteral < SyntaxNode
  end

  class KeyValueList < SyntaxNode
  end

  class KeyValue < SyntaxNode
  end

  #class FunctionCall < SyntaxNode
  #  def to_a
  #    [:function_call, elements.map(&:to_a)]
  #  end
  #end

  class FunctionSubject < SyntaxNode
    def to_coffee
      elements.map(&:to_coffee).join
    end
  end

  class FunctionParamList < SyntaxNode
  end

  class FunctionParams < SyntaxNode
  end

  class FunctionParamKey < SyntaxNode
  end

  class FunctionParamValue < SyntaxNode
  end

  class FunctionBlock < SyntaxNode
  end

  class BlockVariableList < SyntaxNode
  end

  class PropertyAccess < SyntaxNode
  end
end


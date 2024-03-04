# frozen_string_literal: true
require_relative 'Dice'

module Irrgarten
  class CombatElement
    private_class_method :new

    def initialize(effect, uses)
      @effect = effect
      @uses = uses
    end

    protected
    def produce_effect
      if( @uses > 0)
        @uses -= 1
        return @effect
      end
      0
    end

    public
    def discard
      Dice.discard_element(@uses)
    end

    def to_s
      "[" + @effect.to_s + "," + @uses.to_s + "]"
    end
  end
end


# frozen_string_literal: true
require_relative 'Dice'
require_relative 'Player'

module Irrgarten
  class FuzzyPlayer < Player

    def initialize(other)
      super(other.number, other.intelligence, other.strength)
    end

    def move(direction, valid_moves)
      dir = super
      Dice.next_step(dir, valid_moves, intelligence)
    end

    def attack
      sum_weapons + Dice.intensity(strength)
    end

    protected

    def defensive_energy
      sum_shields + Dice.intensity(intelligence)
    end

    public def to_s
      "Fuzzy #{super}"
    end
  end
end

# frozen_string_literal: true
require_relative 'Player'
require_relative 'Dice'
require_relative 'Game'
require_relative 'Directions'
module Irrgarten
  class TestP2
    jugador = Player.new('0', Dice.randomIntelligence, Dice.randomStrength)

    direccion = jugador.move(Directions::LEFT, [Directions::RIGHT, Directions::DOWN])

    game = Game.new(2)
  end
end

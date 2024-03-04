require_relative 'LabyrinthCharacter'

module Irrgarten
  class Monster < LabyrinthCharacter

    @@INITIAL_HEALTH = 5
    def initialize(name, intelligence, strength)
      super(name, intelligence, strength, @@INITIAL_HEALTH)

    end
    def attack
      Dice.intensity(strength)
    end

    def defend(received_attack)
      is_dead = dead

      unless is_dead
        defensive_energy = Dice.intensity(intelligence)
        if defensive_energy < received_attack
          got_wounded
          is_dead = dead
        end
      end

      is_dead
    end

  end
end

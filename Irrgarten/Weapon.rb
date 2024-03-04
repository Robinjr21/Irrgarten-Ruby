require_relative 'Dice'
require_relative 'CombatElement'

module Irrgarten
  class Weapon < CombatElement
    public_class_method :new

    #En ruby el constructor se hereda del padre

    def attack
      self.produce_effect
    end

    def to_s
      "W" + super
    end

  end
end

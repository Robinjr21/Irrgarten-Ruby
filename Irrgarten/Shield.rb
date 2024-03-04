require_relative 'Dice'
require_relative 'CombatElement'

module Irrgarten
  class Shield < CombatElement
    public_class_method :new

    def protect
      self.produce_effect
    end

    def to_s
      "S" + super
    end

  end
end

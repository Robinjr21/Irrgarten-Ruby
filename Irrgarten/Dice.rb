module Irrgarten
  class Dice
    @@MAX_USES = 5
    @@MAX_INTELLIGENCE = 10.0
    @@MAX_STRENGTH = 10.0
    @@RESURRECT_PROB = 0.3
    @@WEAPONS_REWARD = 2
    @@SHIELDS_REWARD = 5
    @@HEALTH_REWARD = 5
    @@MAX_ATTACK =3
    @@MAX_SHIELDS = 2
    @@generator = Random.new

    def self.random_pos(max)
      @@generator.rand(0 .. max)
    end

    def self.who_starts( nplayers)
      @@generator.rand(0 .. nplayers)
    end

    def self.random_intelligence
      @@generator.rand(0.0 .. @@MAX_INTELLIGENCE)
    end

    def self.random_strength
      @@generator.rand(0.0 .. @@MAX_STRENGTH)
    end

    def self.resurrect_player
      if( @@generator.rand < 0.3 ) #generador es una instancia de Random
        true
      else
        false
      end
    end

    def self.weapons_reward
      @@generator.rand(0 .. @@WEAPONS_REWARD+1)
    end

    def self.shields_reward
      @@generator.rand(0 .. @@WEAPONS_REWARD+1)
    end

    def self.health_reward
      @@generator.rand(0 .. @@HEALTH_REWARD)
    end

    def self.weapon_power
      @@generator.rand * @@MAX_ATTACK
    end

    def self.shield_power
      @@generator.rand * @@MAX_SHIELDS
    end

    def self.uses_left
      @@generator.rand(0 .. @@MAX_USES)
    end

    def self.intensity(competence)
      @@generator.rand * competence
    end

    def self.discard_element(usesLeft)
      prob = 1.0 - usesLeft.to_f/@@MAX_USES.to_f
      if( prob > @@generator.rand)
        return true
      else
        false
      end
    end

    def self.next_step(preference, valid_moves, intelligence)
      prob = 1.0 - (intelligence.to_f / @@MAX_INTELLIGENCE.to_f)

      if prob < @@generator.rand
        preference
      else
        index = @@generator.rand(valid_moves.size)
        valid_moves[index]
      end
    end

  end
end

require_relative 'Weapon'
require_relative 'Dice'
require_relative 'Shield'
require_relative 'LabyrinthCharacter'

module Irrgarten
  class Player < LabyrinthCharacter
    @@MAX_WEAPONS = 2
    @@MAX_SHIELDS = 3
    @@INITIAL_HEALTH = 1
    @@HITS2LOSE = 3
    @@PREFIJO = "Player #"

    attr_reader :number, :consecutive_hits
    attr_accessor :weapons, :shields

    def initialize(number, intelligence, strength)
      super("#{@@PREFIJO}#{number}", intelligence, strength, @@INITIAL_HEALTH)
      @number = number

      @weapons = []
      @shields = []

      reset_hits
    end

    def initialize_copy(other)
      super(other)
      reset_hits

      @number = other.number

      for w in other.weapons
        @weapons < w
      end

      for s in other.shields
        @shields < s
      end
    end

    def resurrect
      @health = @@INITIAL_HEALTH
      reset_hits
      @weapons.clear
      @shields.clear
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def dead
      @health == 0
    end

    def attack
      @strength + self.sum_weapons
    end

    def to_s
      "#{@name}
      Number: #{@number}
      Intelligence: #{@intelligence}
      Strength: #{@strength}
      Health: #{@health}
      Row: #{@row}
      Col: #{@col}
      Consecutive hits: #{@consecutiveHits}"
    end

    def new_weapon
      Weapon.new(Dice.weapon_power, Dice.uses_left)
    end

    def new_shield
      Shield.new(Dice.shield_power, Dice.uses_left)
    end

    def defensive_energy
      @intelligence + sum_shields
    end

    def reset_hits
      @consecutiveHits = 0
    end

    def get_wounded
      @health -= 1
    end

    def inc_consecutive_hits
      @consecutiveHits += 1
    end

    def sum_weapons
      total = 0.0

      for w in @weapons
        total += w.attack
      end

      total
    end

    def sum_shields
      total = 0.0

      for w in @shields
        total += w.protect()
      end

      total
    end

    private

    def manage_hit(received_attack)
      defense = self.defensive_energy

      if defense < received_attack
        self.get_wounded
        self.inc_consecutive_hits
      else
        self.reset_hits
      end

      lose = false
      if (@consecutiveHits== @@HITS2LOSE) || (dead)
        self.reset_hits
        lose = true
      end

      lose
    end

    def receive_weapon(w)
      for i in (@weapons.size - 1).downto(0)
        wi = @weapons[i]
        discard = wi.discard
        @weapons.delete(wi) if discard
      end

      size = @weapons.size

      if size < @@MAX_WEAPONS
        @weapons << w
      end
    end

    def receive_shields(s)
      for i in (@shields.size - 1).downto(0)
        si = @shields[i]
        discard = si.discard
        @shields.delete(si) if discard
      end

      size = @shields.size

      if size < @@MAX_SHIELDS
        @shields << s
      end
    end

    public def receive_reward
      w_reward = Dice.weapons_reward
      s_reward = Dice.shields_reward

      w_reward.times do
        w_new = new_weapon
        receive_weapon(w_new)
      end

      s_reward.times do
        s_new = new_shield
        receive_shields(s_new)
      end

      extra_health = Dice.health_reward
      @health += extra_health
    end

    public def move(direction, valid_moves)
      size = valid_moves.size
      contained = valid_moves.include?(direction)

      if size > 0 && !contained
        valid_moves[0]

      else
        direction
      end
    end

    public def defend(receive_attack)
      manage_hit(receive_attack)
    end

  end
end

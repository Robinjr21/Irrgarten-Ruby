# frozen_string_literal: true
module Irrgarten
  class LabyrinthCharacter

    attr_accessor :name, :intelligence, :strength, :health, :row, :col

    def initialize(name, intelligence, strength, health)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = health
      @row = -1
      @col = -1
    end

    def initialize_copy(other)
      @name = other.name
      @intelligence = other.intelligence
      @strength = other.strength
      @health = other.health
      @row = other.row
      @col = other.col
    end

    def dead
      @health == 0
    end

    def set_health(health)
      if health >= 0
        @health = health
      end
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def to_s
      "#{@name}\nIntelligence: #{@intelligence}\nStrength: #{@strength}\nHealth: #{@health}\nRow: #{@row}\nCol: #{@col}"
    end

    def got_wounded
      @health -= 1
    end
  end
end

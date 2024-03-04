require_relative 'Directions'
require_relative 'Weapon'
require_relative 'Dice'
require_relative 'Shield'
require_relative 'GameState'
require_relative 'Player'
require_relative 'Labyrinth'
require_relative 'Game'

module Irrgarten
  class TestP1
    def main
      /
      puts "Random Intelligence"

      for i in 1 .. 10
        puts "Random pos: " + Dice.randomPos(6).to_s
        puts "Who start: " + Dice.whoStarts(6).to_s
        puts "Intelligence: " + Dice.randomIntelligence.to_s
        puts "Random strength: " + Dice.randomStrength.to_s
        puts "Resurrect player: " + Dice.resurrectPlayer.to_s
        puts "Weapons reward: " + Dice.weaponsReward.to_s
        puts "Shield reward: " + Dice.shieldsReward.to_s
        puts "Health reward " + Dice.healthReward.to_s
        puts "Weapon power " + Dice.weaponPower.to_s
        puts "Shield power: " + Dice.shieldPower.to_s
      end

      conT = 0
      conF = 0
      for i in 1 .. 100
        bool = Dice.discardElement(5)
        puts bool

        if(bool == true)
          conT += 1
        else
          conF += 1
        end
      end

      puts "Trues: " + conT.to_s
      puts "Falses: " + conF.to_s

      direccion = Directions::LEFT
      puts "La direccion es " + direccion.to_s

      arma = Weapon.new(10.5, 5)
      puts "Arma: " + arma.to_s
      ataque = arma.attack
      puts "Arma: " + arma.to_s

      weapon = Weapon.new(8.5,5)
      x = weapon

      escudo = Shield.new(8, 4)
      proteje = escudo.protect
      puts "Escudo: " + escudo.to_s

      juego = GameState.new("lab", "playrs", "monst", 2, false, "log")
      puts juego.log
      puts juego.labyrinth
      puts juego.players
      puts juego.monsters
      puts juego.currentPlayer.to_s
      puts juego.winner

      #Prueba player
      p = Player.new('0', Dice.randomIntelligence, Dice.randomStrength)

      suma = p.sumWeapons

      # Prueba labyrinth
      lab = Labyrinth.new(5,7,3,4) /

      game = Game.new(5)

      
    end
  end
end

programa = Irrgarten::TestP1.new
programa.main
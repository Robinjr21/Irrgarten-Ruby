require_relative 'Labyrinth'
require_relative 'Player'
require_relative 'Monster'

module Irrgarten
  class GameState
    attr_reader :labyrinth, :players, :log, :monsters, :currentPlayer, :winner

    def initialize(laberinto, players, monsters, jugActual, win, log)
      @labyrinth = laberinto
      @players = players
      @monsters = monsters
      @currentPlayer = jugActual
      @winner = win
      @log = log
    end


  end
end

require_relative 'Dice'
require_relative 'Player'
require_relative 'Monster'
require_relative 'Labyrinth'
require_relative 'Orientation'
require_relative 'GameCharacter'
require_relative 'FuzzyPlayer'

module Irrgarten
  class Game
    @@MAX_ROUNDS = 10
    @@MAX_MONSTERS = 5

    @@NROWS = 10
    @@NCOLS = 10
    @@EXITROW = 7
    @@EXITCOL = 8

    def initialize(nplayers)
      @players = Array.new(nplayers)
      @monsters = Array.new(@@MAX_MONSTERS)
      @labyrinth = Labyrinth.new(@@NROWS, @@NCOLS, @@EXITROW, @@EXITCOL)
      @log = " "

      for i in (0..(nplayers - 1))
        #p = Player.new(i.to_s, Dice.random_intelligence, Dice.random_strength)
        p = Player.new(i.to_s, 0, 0)
        @players[i] = p
      end

      for i in (0..(@@MAX_MONSTERS-1))
        m = Monster.new("Monster " + i.chr, Dice.random_intelligence, Dice.random_strength)
        @monsters[i] = m
      end

      configure_labyrinth

      @current_player_index = Dice.who_starts(nplayers-1)
      @current_player = @players[@current_player_index]
    end

    def finished
      @labyrinth.have_a_winner
    end

    def game_state
      GameState.new(@labyrinth.to_s, @players.to_s, @monsters.to_s, @current_player, finished, @log.to_s)
    end

    def configure_labyrinth
      @labyrinth.add_block(Orientation::HORIZONTAL, 0, 0, @@NCOLS)
      @labyrinth.add_block(Orientation::VERTICAL, 1, 0, @@NROWS -1)
      @labyrinth.add_block(Orientation::HORIZONTAL, @@NROWS - 1, 1, @@NCOLS -1)
      @labyrinth.add_block(Orientation::VERTICAL, 1, @@NCOLS - 1, @@NCOLS-1)
      @labyrinth.add_block(Orientation::HORIZONTAL, 3, 6, 3)
      @labyrinth.add_block(Orientation::VERTICAL, 5, 3, 3)
      @labyrinth.add_block(Orientation::HORIZONTAL, 6, 7, 2)

      @labyrinth.add_monster(1, 3, @monsters[0])
      @labyrinth.add_monster(2, 6, @monsters[1])
      @labyrinth.add_monster(4, 2, @monsters[2])
      @labyrinth.add_monster(6, 5, @monsters[3])
      @labyrinth.add_monster(8, 6, @monsters[3])

      @labyrinth.spread_players(@players)

    end

    def next_player
      @current_player_index = (@current_player_index + 1) % @players.size
      @current_player = @players[@current_player_index]
    end

    def log_player_won
      @log += "El jugador #{@current_player} ha ganado el combate\n"
    end

    def log_master_won
      @log += "El monstruo ha ganado el combate\n"
    end

    def log_resurrected
      @log += "El jugador  #{@current_player} ha resucitado\n"
    end

    def log_player_skip_turn
      @log += "El jugador  #{@current_player} ha perdido el turno\n"
    end

    def log_player_no_orders
      @log += "El jugador #{@current_player} no ha seguido las instrucciones\n"
    end

    def log_no_monsters
      @log += "El jugador #{@current_player} se ha molvido a una celda vacía\n"
    end

    def log_rounds(rounds, max)
      @log += "Se han producido #{rounds} de #{max} rondas de combate\n"
    end

    def combat(monster)
      rounds = 0
      winner = GameCharacter::PLAYER

      player_attack = @current_player.attack
      lose = monster.defend(player_attack)

      while !lose && (rounds < @@MAX_ROUNDS)
        winner = GameCharacter::MONSTER
        rounds += 1
        monster_attack = monster.attack
        lose = @current_player.defend(monster_attack)

        unless lose
          player_attack = @current_player.attack
          winner = GameCharacter::PLAYER
          lose = monster.defend(player_attack)
        end
      end

      log_rounds(rounds, @@MAX_ROUNDS)

      winner
    end

    def actual_direction(preferred_direction)
      current_row = @current_player.row
      current_col = @current_player.col

      valid_moves = @labyrinth.valid_moves(current_row, current_col)

      @current_player.move(preferred_direction, valid_moves)
    end

    def manage_reward(winner)
      if winner == GameCharacter::PLAYER
        @current_player.receive_reward
        log_player_won
      else
        log_master_won
      end
    end

    def manage_resurrection
      resurrect = Dice.resurrect_player

      if resurrect
        @current_player.resurrect
        log_resurrected

        fuzzyPlayer = FuzzyPlayer.new(@current_player)
        fuzzyPlayer.set_pos(@current_player.row, @current_player.col)
        @current_player = fuzzyPlayer
        @players[@current_player_index] = fuzzyPlayer
        @labyrinth.set_fuzzy_player(fuzzyPlayer)
      else
        log_player_skip_turn
      end
    end

    def next_step(preferred_direction)
      @log = " "

      dead = @current_player.dead

      if !dead
        direction = actual_direction(preferred_direction)

        if direction != preferred_direction
          log_player_no_orders
        end

        monster = @labyrinth.put_player(direction, @current_player)

        if monster.nil?
          log_no_monsters
        else
          winner = combat(monster)
          manage_reward(winner)
        end
      else
        manage_resurrection
      end

      end_game = finished

      if !end_game
        next_player
      end

      end_game
    end
  end
end


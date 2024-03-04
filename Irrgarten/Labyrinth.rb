require_relative 'Dice'
require_relative 'Monster'

module Irrgarten
  class Labyrinth
    @@BLOCK_CHAR = 'X'
    @@EMPTY_CHAR = '-'
    @@MONSTER_CHAR = 'M'
    @@COMBAT_CHAR = 'C'
    @@EXIT_CHAR = 'E'
    @@ROW = 0
    @@COL = 1

    def initialize(nRows, nCols, exitRow, exitCol)
      @nRows = nRows
      @nCols = nCols
      @exitRow = exitRow
      @exitCol = exitCol

      @players = Array.new(@nRows) { Array.new(@nCols, nil) }
      @monsters = Array.new(@nRows) { Array.new(@nCols, nil) }
      @labyrinth = Array.new(@nRows) { Array.new(@nCols, @@EMPTY_CHAR) }

      @labyrinth[@exitRow][@exitCol] = @@EXIT_CHAR
    end

    def have_a_winner
      !@players[@exitRow][@exitCol].nil?
    end

    def add_monster(row, col, monster)
      if pos_ok(row, col) && empty_pos(row, col)
        @monsters[row][col] = monster
        @monsters[row][col].set_pos(row, col)
        @labyrinth[row][col] = @@MONSTER_CHAR
      end
    end

    def pos_ok(row, col)
      (row >= 0 && row < @nRows && col >= 0 && col < @nCols)
    end

    def empty_pos(row, col)
      ((@labyrinth[row][col] != @@COMBAT_CHAR) &&
        (@labyrinth[row][col] != @@MONSTER_CHAR) &&
        (@labyrinth[row][col] != @@BLOCK_CHAR))
    end

    def monster_pos(row, col)
      @labyrinth[row][col] == @@MONSTER_CHAR
    end

    def exit_pos(row, col)
      @labyrinth[row][col] == @@EXIT_CHAR
    end

    def combat_pos(row, col)
      @labyrinth[row][col] == @@COMBAT_CHAR
    end

    def can_step_on(row, col)
      (pos_ok(row, col) && (empty_pos(row, col) || monster_pos(row, col) || combat_pos(row, col)))
    end

    def update_old_pos(row, col)
      if pos_ok(row, col)
        if combat_pos(row, col)
          @labyrinth[row][col] = @@MONSTER_CHAR
        else
          @labyrinth[row][col] = @@EMPTY_CHAR
        end
      end
    end

    def dir_to_pos(row, col, directions)
      sol = [row, col]

      case directions
        when :LEFT
          sol[@@COL] -= 1
        when :RIGHT
          sol[@@COL] += 1
        when :UP
          sol[@@ROW] -= 1
        when :DOWN
        sol[@@ROW] += 1
      end

      sol
    end

    def random_empty_pos
      sol = [0, 0]
      encontrado = false

      while !encontrado
        fil = Dice.random_pos(@nRows-1)
        col = Dice.random_pos(@nCols-1)

        if @labyrinth[fil][col] == @@EMPTY_CHAR
          sol[@@ROW] = fil
          sol[@@COL] = col

          encontrado = true
        end
      end

      sol
    end

    def to_s
      # sol = "nRows: #{@nRows}\nnCols: #{@nCols}\nexitRow: #{@exitRow}\nexitCol: #{@exitCol}\nLabyrinth: \n"
      sol = ""
      (0...@nRows).each do |i|
        (0...@nCols).each do |j|
          sol += "#{@labyrinth[i][j]} "
        end
        sol += "\n"
      end
      sol
    end


    def add_block(orientation, start_row, start_col, length)
      inc_row = 0
      inc_col = 0

      if orientation == Orientation::VERTICAL
        inc_row = 1
      else
        inc_col = 1
      end

      row = start_row
      col = start_col

      i = 0
      while (pos_ok(row, col)) && (empty_pos(row, col)) && (length > 0)
        @labyrinth[row][col] = @@BLOCK_CHAR
        length -= 1
        row += inc_row
        col += inc_col
      end
    end

    def valid_moves(row, col)
      output = []

      if can_step_on(row + 1, col)
        output.push(Directions::DOWN)
      end
      if can_step_on(row - 1, col)
        output.push(Directions::UP)
      end
      if can_step_on(row, col + 1)
        output.push(Directions::RIGHT)
      end
      if can_step_on(row, col - 1)
        output.push(Directions::LEFT)
      end

      output
    end

    def put_player(direction, player)
      old_row = player.row
      old_col = player.col
      new_pos = dir_to_pos(old_row, old_col, direction)
      row = new_pos[@@ROW]
      col = new_pos[@@COL]

      put_player_2d(old_row, old_col, row, col, player)

    end

    def put_player_2d(old_row, old_col, row, col, player)
      output = nil

      if can_step_on(row, col)
        if pos_ok(old_row, old_col)
          p = @players[old_row][old_col]
          if p == player
            update_old_pos(old_row, old_col)
            @players[old_row][old_col] = nil
          end
        end
      end

      monster_pos = self.monster_pos(row, col)

      if monster_pos
        @labyrinth[row][col] = @@COMBAT_CHAR
        output = @monsters[row][col]
      else
        number = player.number
        @labyrinth[row][col] = number
      end

      @players[row][col] = player
      player.set_pos(row, col)

      output
    end

    def spread_players(players)
      players.each do |p|
        pos = random_empty_pos
        old_row = -1
        old_col = -1
        row = pos[@@ROW]
        col = pos[@@COL]
        self.put_player_2d(old_row, old_col, row, col, p)
      end
    end

    def set_fuzzy_player(fuzzy_player)
      @players[fuzzy_player.row][fuzzy_player.col] = fuzzy_player
    end

  end
end

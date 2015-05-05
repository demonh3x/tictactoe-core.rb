require 'core/state'
require 'boards/board_type_factory'
require 'players/ai/perfect_player'
require 'players/ai/random_chooser'

module Core
  class TicTacToe
    def initialize()
      @players = [:x, :o].cycle
    end

    def set_board_size(size)
      @size = size
      @board = Boards::BoardTypeFactory.new.create(size)
      @state = State.new(@board)
    end

    def set_player_x(type)
    end

    def set_player_o(type)
    end

    def tick(move)
      if is_valid?(move) && !is_finished?
        @state = @state.make_move(move, current_mark)
        @players.next
      end
    end

    def is_finished?
      @state.when_finished{true} || false
    end

    def winner
      @state.when_finished{|winner| winner}
    end

    def marks
      @state.layout.map{|loc, mark| mark}
    end

    def available
      @state.available_moves
    end

    private
    def is_valid?(move)
      move != nil && @state.available_moves.include?(move)
    end

    def current_mark
      @players.peek
    end
  end
end

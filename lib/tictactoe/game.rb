require 'tictactoe/state'
require 'tictactoe/players'
require 'tictactoe/boards/board_type_factory'
require 'tictactoe/ai/perfect_player'
require 'tictactoe/ai/random_chooser'

module Tictactoe
  class Game
    def initialize(random=Random.new)
      @players = Players.new(:x, :o)
      @current_player = @players.first
      @types = {}
      chooser = Ai::RandomChooser.new(random)
      @ais = {
        :x => Ai::PerfectPlayer.new(@players.first, chooser),
        :o => Ai::PerfectPlayer.new(@players.first.next, chooser),
      }
    end

    def set_board_size(size)
      @size = size
      @board = Boards::BoardTypeFactory.new.create(size)
      @state = State.new(@board)
    end

    def set_player_x(type)
      @types[:x] = type
    end

    def set_player_o(type)
      @types[:o] = type
    end

    def tick(user)
      move = get_move(user)
      if is_valid?(move) && !is_finished?
        @state = @state.make_move(move, current_mark)
        @current_player = @current_player.next
      end
    end

    def is_finished?
      @state.when_finished{true} || false
    end

    def winner
      @state.when_finished{|winner| winner}
    end

    def marks
      @state.layout
    end

    def available
      @state.available_moves
    end

    private
    def is_valid?(move)
      move != nil && @state.available_moves.include?(move)
    end

    def current_mark
      @current_player.mark
    end

    def get_move(user)
      if is_users_turn?
        user.get_move!
      else
        ai = @ais[current_mark]
        ai.update(@state)
        ai.play_location
      end
    end

    def is_users_turn?
      @types[current_mark] == :human
    end
  end
end

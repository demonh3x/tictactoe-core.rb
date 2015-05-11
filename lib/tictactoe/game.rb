require 'tictactoe/state'
require 'boards/board_type_factory'
require 'tictactoe/ai/perfect_player'
require 'tictactoe/ai/random_chooser'

module Tictactoe
  class Game
    def initialize(random=Random.new)
      @players = [:x, :o].cycle
      @types = {}
      chooser = Tictactoe::Ai::RandomChooser.new(random)
      @ais = {
        :x => Tictactoe::Ai::PerfectPlayer.new(:x, :o, chooser),
        :o => Tictactoe::Ai::PerfectPlayer.new(:o, :x, chooser),
      }
    end

    def set_board_size(size)
      @size = size
      @board = Boards::BoardTypeFactory.new.create(size)
      @state = Tictactoe::State.new(@board)
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

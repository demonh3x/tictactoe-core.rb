require 'tictactoe/state'
require 'tictactoe/players'
require 'tictactoe/boards/board_type_factory'
require 'tictactoe/ai/perfect_player'
require 'tictactoe/ai/random_chooser'

module Tictactoe
  class Game
    attr_reader :current_player, :ais, :moves_source

    def initialize(board_size, x_type, o_type, moves_source, random=Random.new)
      players = Players.new(:x, :o)
      @current_player = players.first

      @moves_source = moves_source

      chooser = Ai::RandomChooser.new(random)
      @ais = {
        :x => Ai::PerfectPlayer.new(Ai::Intelligence.new(players.first), chooser),
        :o => Ai::PerfectPlayer.new(Ai::Intelligence.new(players.first.next), chooser),
      }
      @types = {
        :x => x_type,
        :o => o_type
      }

      @state = State.new(Boards::BoardTypeFactory.new.create(board_size))
    end

    def tick()
      move = get_move()
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

    def get_move()
      if is_users_turn?
        moves_source.get_move!
      else
        ai = ais[current_mark]
        ai.get_move(@state)
      end
    end

    def is_users_turn?
      @types[current_mark] == :human
    end
  end
end

require 'tictactoe/state'
require 'tictactoe/sequence'
require 'tictactoe/boards/square'

module Tictactoe
  class Game
    attr_accessor :current_player, :state
    attr_accessor :board_size, :x_type, :o_type

    def initialize(players_factory, board_size, x_type, o_type)
      self.players_factory = players_factory
      self.board_size = board_size
      self.x_type = x_type
      self.o_type = o_type
      reset
    end

    def tick
      move = get_move
      if is_valid?(move) && !is_finished?
        update_state(move)
        advance_player
      end
    end

    def ready_to_tick?
      current_player.value.ready_to_move?
    end

    def is_finished?
      state.is_finished?
    end

    def winner
      state.winner
    end

    def marks
      state.marks
    end

    def available
      state.available_moves
    end

    private
    attr_accessor :players_factory

    def is_valid?(move)
      move && state.available_moves.include?(move)
    end

    def update_state(move)
      self.state = state.make_move(move, current_player.value.mark.value)
    end

    def advance_player
      self.current_player = current_player.next
    end

    def get_move
      current_player.value.get_move(state)
    end

    def reset
      reset_players
      reset_state
    end

    def reset_players
      first_mark = Sequence.new([:x, :o]).first
      players = [first_mark, first_mark.next].zip([x_type, o_type]).map do |mark, type|
        players_factory.create(type, mark)
      end

      self.current_player = Sequence.new(players).first
    end

    def reset_state
      self.state = State.new(Boards::Square.new(board_size))
    end
  end
end

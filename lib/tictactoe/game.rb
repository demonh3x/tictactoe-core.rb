require 'tictactoe/state'
require 'tictactoe/sequence'
require 'tictactoe/boards/board_type_factory'

module Tictactoe
  class Game
    attr_accessor :current_player, :state

    def initialize(players_factory, board_size, player_types)
      self.players_factory = players_factory
      self.board_size = board_size
      self.player_types = player_types
      reset
    end

    def tick
      move = get_move
      if is_valid?(move) && !is_finished?
        update_state(move)
        advance_player
      end
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
    attr_accessor :players_factory, :board_size, :player_types

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
      players = [first_mark, first_mark.next].zip(player_types).map do |mark, type|
        players_factory.create(type, mark)
      end

      self.current_player = Sequence.new(players).first
    end

    def reset_state
      self.state = State.new(Boards::BoardTypeFactory.new.create(board_size))
    end
  end
end

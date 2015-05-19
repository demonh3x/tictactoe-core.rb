require 'tictactoe/state'
require 'tictactoe/sequence'
require 'tictactoe/boards/board_type_factory'
require 'tictactoe/ai/computer_player'
require 'tictactoe/ai/perfect_intelligence'
require 'tictactoe/ai/random_chooser'

module Tictactoe
  class Game
    class PlayersFactory
      class Human
        attr_reader :moves_source

        def initialize(moves_source)
          @moves_source = moves_source
        end

        def get_move(state)
          moves_source.get_move!()
        end
      end

      class Computer
        attr_reader :ai

        def initialize(mark, random)
          @ai = Ai::ComputerPlayer.new(
            Ai::PerfectIntelligence.new(mark),
            Ai::RandomChooser.new(random)
          )
        end

        def get_move(state)
          ai.get_move(state)
        end
      end

      attr_reader :moves_source, :random

      def initialize(user_moves_source, random)
        @moves_source = user_moves_source
        @random = random
      end

      def create(type, mark)
        case type
        when :human
          Human.new(moves_source)
        when :computer
          Computer.new(mark, random)
        end
      end
    end

    attr_accessor :current_mark, :current_player, :state

    def initialize(board_size, x_type, o_type, user_moves_source, random=Random.new)
      players_factory = PlayersFactory.new(user_moves_source, random)
      board_factory = Boards::BoardTypeFactory.new()

      first_mark = Sequence.new([:x, :o]).first()
      @current_mark = first_mark

      types = {
        first_mark => x_type,
        first_mark.next => o_type,
      }
      players = types.map do |mark, type|
        players_factory.create(type, mark)
      end
      @current_player = Sequence.new(players).first()

      @state = State.new(board_factory.create(board_size))
    end

    def tick()
      move = get_move()
      if is_valid?(move) && !is_finished?()
        update_state(move)
        advance_player()
      end
    end

    def is_finished?()
      state.is_finished?()
    end

    def winner()
      state.winner()
    end

    def marks()
      state.layout()
    end

    def available()
      state.available_moves()
    end

    private
    def is_valid?(move)
      move != nil && state.available_moves.include?(move)
    end

    def update_state(move)
      self.state = state.make_move(move, current_mark.value())
    end

    def advance_player()
      self.current_mark = current_mark.next()
      self.current_player = current_player.next()
    end

    def get_move()
      current_player.value.get_move(state)
    end
  end
end

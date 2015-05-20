require 'tictactoe/state'
require 'tictactoe/sequence'
require 'tictactoe/boards/board_type_factory'
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
          moves_source.get_move!
        end
      end

      class Computer
        attr_reader :mark, :intelligence, :chooser

        def initialize(mark, intelligence, chooser)
          @mark = mark
          @intelligence = intelligence
          @chooser = chooser
        end

        def get_move(state)
          chooser.choose_one(intelligence.desired_moves(state, mark))
        end
      end

      attr_reader :moves_source, :chooser, :intelligence

      def initialize(user_moves_source, random)
        @moves_source = user_moves_source
        @chooser = Ai::RandomChooser.new(random)
        @intelligence = Ai::PerfectIntelligence.new
      end

      def create(type, mark)
        case type
        when :human
          Human.new(moves_source)
        when :computer
          Computer.new(mark, intelligence, chooser)
        end
      end
    end

    attr_accessor :board_size, :x_type, :o_type, :random, :user_moves_source
    attr_accessor :current_mark, :current_player, :state

    def initialize(board_size, x_type, o_type, random=Random.new)
      @board_size = board_size
      @x_type = x_type
      @o_type = o_type
      @random = random
    end

    def user_moves=(user_moves_source)
      self.user_moves_source = user_moves_source
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
      state.layout
    end

    def available
      state.available_moves
    end

    private
    def is_valid?(move)
      move != nil && state.available_moves.include?(move)
    end

    def update_state(move)
      self.state = state.make_move(move, current_mark.value)
    end

    def advance_player
      self.current_mark = current_mark.next
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

      factory = PlayersFactory.new(user_moves_source, random)
      x_player = factory.create(x_type, first_mark)
      o_player = factory.create(o_type, first_mark.next)

      self.current_mark = first_mark
      self.current_player = Sequence.new([x_player, o_player]).first
    end

    def reset_state
      self.state = State.new(Boards::BoardTypeFactory.new.create(board_size))
    end
  end
end

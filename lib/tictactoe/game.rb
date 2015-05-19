require 'tictactoe/state'
require 'tictactoe/players'
require 'tictactoe/boards/board_type_factory'
require 'tictactoe/ai/computer_player'
require 'tictactoe/ai/perfect_intelligence'
require 'tictactoe/ai/random_chooser'

module Tictactoe
  class Game
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

    def create_player(mark, type)
      case type
      when :human
        Human.new(moves_source)
      when :computer
        Computer.new(mark, random)
      end
    end

    attr_reader :current_mark, :ais, :moves_source, :random, :players
    def initialize(board_size, x_type, o_type, user_moves_source, random=Random.new)
      marks = Players.new(:x, :o)
      @current_mark = marks.first

      @moves_source = user_moves_source
      @random = random

      ts = {
        marks.first => x_type,
        marks.first.next => o_type,
      }
      players = ts.map do |mark, type|
        create_player(mark, type)
      end
      @players = players.cycle

      @state = State.new(Boards::BoardTypeFactory.new.create(board_size))
    end

    def tick()
      move = get_move()
      if is_valid?(move) && !is_finished?
        update_state(move)
        advance_player
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
      @current_mark.mark
    end

    def update_state(move)
      @state = @state.make_move(move, current_mark)
    end

    def advance_player
      @current_mark = @current_mark.next
      @players.next
    end

    def current_player
      @players.peek
    end

    def get_move
      current_player.get_move(@state)
    end
  end
end

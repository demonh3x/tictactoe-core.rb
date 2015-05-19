require 'tictactoe/ai/ab_minimax'
require 'tictactoe/ai/ab_negamax'

module Tictactoe
  module Ai
    class PerfectPlayer
      MAXIMUM_SCORE = 2
      MINIMUM_SCORE = -2
      NEUTRAL_SCORE = 0
      SCORE_FOR_UNKNOWN_FUTURE = -1

      class Intelligence
        attr_reader :mark

        def initialize(mark)
          @mark = mark 
        end

        def desired_moves(state)
          find_best_locations(state).map(&:transition)
        end

        private
        def find_best_locations(state)
          depth = dynamic_depth_for state
          ai = ABNegamax.new(depth, SCORE_FOR_UNKNOWN_FUTURE)
          root = Node.new(state, mark, opponent(mark), mark)
          ai.best_nodes(root)
        end

        def opponent(mark)
          mark == :x ? :o : :x
        end

        def dynamic_depth_for(state)
          played_moves = state.board.locations.length - state.available_moves.length

          if state.board.locations.length == 16
            depth = [7, played_moves].min
          else
            played_moves += 4
            depth = [5, played_moves].min
          end

          depth
        end
      end

      class Node
        def initialize(state, me, opponent, current_player, transition=nil)
          @state = state
          @me = me
          @opponent = opponent
          @current_player = current_player
          @transition = transition
        end
        attr_reader :state, :me, :opponent, :current_player, :transition

        def is_final?
          state.when_finished{true} || false
        end

        def childs
          state.available_moves.lazy.map do |transition|
            next_player = current_player == me ? opponent : me
            next_state = state.make_move transition, current_player
            Node.new(next_state, me, opponent, next_player, transition)
          end
        end

        def score 
          depth = state.available_moves.length + 1
          base_score * depth
        end

        def base_score
          state.when_finished do |winner|
            case winner
            when me
              MAXIMUM_SCORE
            when nil
              NEUTRAL_SCORE
            else
              MINIMUM_SCORE
            end
          end
        end
      end

      def initialize(mark, opponents_mark, chooser)
        @mark = mark
        @opponents_mark = opponents_mark
        @chooser = chooser
      end

      attr_accessor :mark, :opponents_mark, :state

      def update(state)
        self.state = state
      end

      def play_location
        options = desired_moves
        @chooser.choose_one(options)
      end

      def desired_moves
        Intelligence.new(mark).desired_moves(state)
      end
    end
  end
end

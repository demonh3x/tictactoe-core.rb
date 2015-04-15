require 'players/ai/ab_minimax'
require 'players/ai/minimax'

class PerfectPlayer
  DEPTH_LIMIT = 3
  MINIMUM_SCORE_POSSIBLE = -2
  SCORE_FOR_UNKNOWN_FUTURE = -1

  module TTT
    class Node
      def initialize(state, me, opponent, current_player, transition = nil)
        @state = state
        @me = me
        @opponent = opponent
        @current_player = current_player
        @transition = transition
      end
      attr_reader :state, :me, :transition, :opponent, :current_player

      def is_final?(state)
        state.when_finished{true} || false
      end

      def childs
        return [] if is_final?(state)

        c = state.available_moves.lazy.map do |transition|
          next_player = current_player == me ? opponent : me
          next_state = state.make_move transition, current_player
          Node.new(next_state, me, opponent, next_player, transition)
        end

        def c.empty?
          false
        end

        c
      end

      def score
        state.when_finished do |winner|
          case winner
          when me
            2
          when nil
            0
          else
            -2
          end
        end
      end
    end
  end

  def initialize(my_mark, opponents_mark)
    ab_minimax = ABMinimax.new(MINIMUM_SCORE_POSSIBLE, SCORE_FOR_UNKNOWN_FUTURE, DEPTH_LIMIT)

    @strategy = lambda do |state|

      locs = ab_minimax.evaluate(TTT::Node.new(state, my_mark, opponents_mark, my_mark)).map(&:transition)

      locs
    end
  end

  def call(state)
    @strategy.call(state)
  end
end

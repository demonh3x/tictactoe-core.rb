module Tictactoe
  module Ai
    class Tree
      MAXIMUM_SCORE = 2
      MINIMUM_SCORE = -2
      NEUTRAL_SCORE = 0

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
          Tree.new(next_state, me, opponent, next_player, transition)
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
  end
end

module Tictactoe
  module Ai
    class Tree
      MAXIMUM_SCORE = 2
      MINIMUM_SCORE = -2
      NEUTRAL_SCORE = 0

      def initialize(state, me, current_player = me, transition=nil)
        @state = state
        @me = me
        @current_player = current_player
        @transition = transition
      end
      attr_reader :state, :me, :current_player, :transition

      def is_final?
        state.is_finished?
      end

      def childs
        state.available_moves.lazy.map do |transition|
          next_state = state.make_move(transition, current_player.value)
          Tree.new(next_state, me, current_player.next, transition)
        end
      end

      def score 
        depth = state.available_moves.length + 1
        base_score * depth
      end

      def base_score
        case state.winner
        when me.value
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

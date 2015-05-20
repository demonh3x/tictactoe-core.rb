module Tictactoe
  module Ai
    class Tree
      MAXIMUM_SCORE = 2
      MINIMUM_SCORE = -2
      NEUTRAL_SCORE = 0

      def initialize(state, me, current_player = me, move_to_arrive_here=nil)
        @state = state
        @me = me
        @current_player = current_player
        @move = move_to_arrive_here
      end
      attr_reader :state, :me, :current_player, :move

      def is_final?
        state.is_finished?
      end

      def childs
        state.available_moves.map do |move|
          next_state = state.make_move(move, current_player.value)
          Tree.new(next_state, me, current_player.next, move)
        end
      end

      def score 
        height = state.available_moves.length + 1
        base_score * height
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

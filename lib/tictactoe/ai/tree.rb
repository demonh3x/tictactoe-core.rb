module Tictactoe
  module Ai
    class Tree
      MAXIMUM_SCORE = 2
      MINIMUM_SCORE = -2
      NEUTRAL_SCORE = 0

      def initialize(state, mark, current_mark = mark, move_to_arrive_here=nil)
        @state = state
        @mark = mark
        @current_mark = current_mark
        @move = move_to_arrive_here
      end
      attr_reader :state, :mark, :current_mark, :move

      def is_final?
        state.is_finished?
      end

      def children
        state.available_moves.map do |move|
          next_state = state.make_move(move, current_mark.value)
          Tree.new(next_state, mark, current_mark.next, move)
        end
      end

      def score 
        height = state.available_moves.length + 1
        base_score * height
      end

      def base_score
        case state.winner
        when mark.value
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

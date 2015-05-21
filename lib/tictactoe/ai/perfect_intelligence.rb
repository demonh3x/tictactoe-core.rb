require 'tictactoe/ai/ab_minimax'
require 'tictactoe/ai/tree'

module Tictactoe
  module Ai
    class PerfectIntelligence
      SCORE_FOR_UNKNOWN_FUTURE = -1

      def desired_moves(state, player)
        find_best_moves(state, player)
      end

      private
      def find_best_moves(state, player)
        depth = dynamic_depth_for(state)
        root = Tree.new(state, player)
        ai = ABMinimax.new(-1000, SCORE_FOR_UNKNOWN_FUTURE, depth)
        ai.best_nodes(root).map(&:move)
      end

      def dynamic_depth_for(state)
        played_moves = state.board.locations.length - state.available_moves.length

        is_4_by_4 = state.board.locations.length == 16
        if is_4_by_4
          initial_depth_to_stay_out_of_trouble = 0
          minimum_depth_to_avoid_lethal_moves = 7
        else
          initial_depth_to_stay_out_of_trouble = 4
          minimum_depth_to_avoid_lethal_moves = 5
        end

        [minimum_depth_to_avoid_lethal_moves, played_moves + initial_depth_to_stay_out_of_trouble].min
      end
    end
  end
end

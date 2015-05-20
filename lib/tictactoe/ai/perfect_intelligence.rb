require 'tictactoe/ai/ab_negamax'
require 'tictactoe/ai/tree'

module Tictactoe
  module Ai
    class PerfectIntelligence
      SCORE_FOR_UNKNOWN_FUTURE = -1

      attr_reader :own_mark

      def initialize(own_mark)
        @own_mark = own_mark
      end

      def desired_moves(state)
        find_best_locations(state).map(&:transition)
      end

      private
      def find_best_locations(state)
        depth = dynamic_depth_for state
        ai = ABNegamax.new(depth, SCORE_FOR_UNKNOWN_FUTURE)
        root = Tree.new(state, own_mark)
        ai.best_nodes(root)
      end

      def dynamic_depth_for(state)
        played_moves = state.board.locations.length - state.available_moves.length

        if state.board.locations.length == 16
          minimum_depth_to_avoid_lethal_moves = 7
          depth = [minimum_depth_to_avoid_lethal_moves, played_moves].min
        else
          played_moves += 4
          minimum_depth_to_avoid_lethal_moves = 5
          depth = [minimum_depth_to_avoid_lethal_moves, played_moves].min
        end

        depth +1
      end
    end
  end
end

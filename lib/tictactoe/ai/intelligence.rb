require 'tictactoe/ai/ab_negamax'
require 'tictactoe/ai/tree'

module Tictactoe
  module Ai
    class Intelligence
      SCORE_FOR_UNKNOWN_FUTURE = -1

      attr_reader :player

      def initialize(player)
        @player = player
      end

      def desired_moves(state)
        find_best_locations(state).map(&:transition)
      end

      private
      def find_best_locations(state)
        depth = dynamic_depth_for state
        ai = ABNegamax.new(depth, SCORE_FOR_UNKNOWN_FUTURE)
        root = Tree.new(state, player.mark, player.next.mark, player.mark)
        ai.best_nodes(root)
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
  end
end

module Tictactoe
  module Ai
    class ABNegamax
      COLOR_SELF = 1
      COLOR_OPPONENT = -1

      def initialize(depth_limit, depth_reached_score)
        @depth_limit = depth_limit
        @depth_reached_score = depth_reached_score
      end

      attr_reader :depth_reached_score, :depth_limit

      def score(tree)
        negamax(tree)[:score]
      end

      def best_nodes(tree)
        negamax(tree)[:nodes]
      end
      
      private
      def negamax(node, depth = depth_limit, a = -1000, b = 1000, color = COLOR_SELF)
        return {:score => color * node.score, :nodes => []} if node.is_final?
        return {:score => color * depth_reached_score, :nodes => node.childs} if depth == 0

        best_score = -1000
        best_nodes = []
        node.childs.each do |child|
          score = -negamax(child, depth-1, -b, -a, -color)[:score]
          if score > best_score
            best_score = score
            best_nodes = [child]
          elsif score == best_score
            best_nodes << child
          end
          a = [a, score].max
          break if a > b
        end

        {:score => best_score, :nodes => best_nodes}
      end
    end
  end
end

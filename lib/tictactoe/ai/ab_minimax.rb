module Tictactoe
  module Ai
    class ABMinimax
      def initialize(min_score, heuristic_score, depth_limit)
        @min_score_possible = min_score
        @heuristic_score = heuristic_score
        @depth_limit = depth_limit
      end

      def best_nodes(tree)
        most_beneficial_strategy(tree, nil, depth_limit)[:nodes]
      end

      private
      attr_reader :min_score_possible, :heuristic_score, :depth_limit

      def most_beneficial_strategy(tree, previous_most_damaging_score, depth)
        my_best_score = min_score_possible
        best_nodes = []

        tree.children.each do |child|
          if child.is_final?
            score = child.score
          elsif depth == 0
            score = heuristic_score
          else
            score = most_damaging_score(child, my_best_score, depth-1)
          end

          my_best_score ||= score

          if score == my_best_score
            best_nodes << child
          end

          if score > my_best_score
            my_best_score = score
            best_nodes = [child]
          end

          break if previous_most_damaging_score && previous_most_damaging_score <= score
        end

        return {
          :score => my_best_score,
          :nodes => best_nodes
        }
      end

      def most_damaging_score(child, my_best_score, depth)
        most_damaging_score = nil

        child.children.each do |grandchild|
          if grandchild.is_final?
            minimizing_score = grandchild.score
          elsif depth == 0
            minimizing_score = heuristic_score
          else
            res = most_beneficial_strategy(grandchild, most_damaging_score, depth-1)
            minimizing_score = res[:score]
          end

          most_damaging_score ||= minimizing_score

          if minimizing_score < most_damaging_score
            most_damaging_score = minimizing_score
          end

          it_cannot_be_worse = min_score_possible && most_damaging_score == min_score_possible
          there_is_a_better_option = my_best_score && most_damaging_score < my_best_score
          break if it_cannot_be_worse || there_is_a_better_option
        end

        most_damaging_score
      end
    end
  end
end

class ABMinimax
  def initialize(min_score_possible=nil)
    @min_score_possible = min_score_possible
  end

  attr_reader :min_score_possible

  def evaluate(tree)
    my_best_score = min_score_possible
    best_nodes = []

    tree.childs.each do |child|
      if is_final?(child)
        score = child.score
      else
        most_damaging_score = nil

        child.childs.each do |grandchild|
          minimizing_score = grandchild.score
          most_damaging_score ||= minimizing_score

          if minimizing_score < most_damaging_score
            most_damaging_score = minimizing_score
          end
          
          it_cant_be_worse = min_score_possible &&
            most_damaging_score == min_score_possible
          there_is_a_better_option = my_best_score &&
            most_damaging_score < my_best_score

          break if it_cant_be_worse || there_is_a_better_option
        end

        score = most_damaging_score
      end

      my_best_score ||= score

      if score == my_best_score
        best_nodes << child
      end

      if score > my_best_score
        my_best_score = score
        best_nodes = [child]
      end
    end

    return best_nodes
  end

  def is_final?(tree)
    tree.childs.empty?
  end
end

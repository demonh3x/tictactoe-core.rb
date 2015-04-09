class ABMinimax
  def evaluate(tree)
    my_best_score = nil
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
          
          child_is_not_going_to_be_chosen =
            my_best_score && most_damaging_score < my_best_score

          break if child_is_not_going_to_be_chosen
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

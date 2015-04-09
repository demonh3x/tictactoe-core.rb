class ABMinimax
  def evaluate(tree)
    best_score = nil
    best_nodes = []

    tree.childs.each do |child|
      if has_childs?(child)
        worst_score = nil

        child.childs.each do |grandchild|
          minimizing_score = grandchild.score
          worst_score ||= minimizing_score
          worst_score = minimizing_score if minimizing_score < worst_score
          break if best_score && worst_score < best_score
        end

        score = worst_score
      else
        score = child.score
      end

      best_score ||= score

      if score == best_score
        best_nodes << child
      end

      if score > best_score
        best_score = score
        best_nodes = [child]
      end
    end

    return best_nodes
  end

  def has_childs?(tree)
    !tree.childs.empty?
  end
end

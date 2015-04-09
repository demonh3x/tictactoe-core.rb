class ABMinimax
  def initialize(min_score)
    @min_score = min_score
  end

  attr_reader :min_score

  def evaluate(tree)
    best_score = min_score
    best_nodes = []

    tree.childs.each do |child|
      if has_childs?(child)
        grandchild = child.childs[0]
        
        if !has_childs?(grandchild)
          score = grandchild.score
        else
          score = -1
        end
      else
        score = child.score
      end

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

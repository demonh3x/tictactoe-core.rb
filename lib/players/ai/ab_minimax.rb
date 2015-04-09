class ABMinimax
  def initialize(min_score)
    @min_score = min_score
  end

  attr_reader :min_score

  def evaluate(tree)
    best_score = min_score
    best_nodes = []

    tree.childs.each do |child|
      if !is_leaf?(child)
        score = -1
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

  def is_leaf?(tree)
    tree.childs.empty?
  end
end

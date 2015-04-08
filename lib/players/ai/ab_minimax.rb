class ABMinimax
  def initialize(min_score)
    @min_score = min_score
  end

  attr_reader :min_score

  def evaluate(tree)
    best_score = min_score
    best_nodes = []

    tree.childs.each do |child|
      if child.score == best_score
        best_nodes << child
      end

      if child.score > best_score
        best_score = child.score
        best_nodes = [child]
      end
    end

    return best_nodes
  end
end

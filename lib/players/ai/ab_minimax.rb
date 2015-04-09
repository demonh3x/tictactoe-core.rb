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
        if tree.childs.size == 1
          a = tree.childs[0]
          return [a]
        end

        if tree.childs.size == 2
          a = tree.childs[0]
          b = tree.childs[1]
          choice = a if is_leaf? a
          choice = b if is_leaf? b
          return [choice]
        end
      end

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

  def is_leaf?(tree)
    tree.childs.empty?
  end
end

class ABMinimax
  def evaluate(tree)
    if tree.childs.size == 0
      return []
    end

    first = tree.childs[0]
    if tree.childs.size == 1
      return [first]
    end

    first = tree.childs[0]
    second = tree.childs[1]
    if tree.childs.size == 2
      if first.score > second.score
        return [first]
      end

      if first.score < second.score
        return [second]
      end

      return [first, second]
    end
  end

end

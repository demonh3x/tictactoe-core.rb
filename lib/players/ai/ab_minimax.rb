class ABMinimax
  def evaluate(tree)
    if tree.childs.size == 0
      return e(tree)
    end

    first = tree.childs[0]
    if tree.childs.size == 1
      return s(first)
    end

    second = tree.childs[1]
    if tree.childs.size == 2
      if first.score > second.score
        return s(first)
      end

      return s(second)
    end
  end

  def e(node)
    {
      :score => node.score,
      :options => []
    }
  end

  def s(node)
    {
      :score => node.score,
      :options => [node]
    }
  end
end

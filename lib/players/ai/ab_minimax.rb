class ABMinimax
  def evaluate(tree)
    if tree.childs.size == 0
      return e(tree)
    end

    first = tree.childs[0]
    if tree.childs.size == 1
      return s(first)
    end

    first = tree.childs[0]
    second = tree.childs[1]
    if tree.childs.size == 2
      if first.score > second.score
        return s(first)
      end

      if first.score < second.score
        return s(second)
      end

      return s(first, second)
    end
  end

  def e(node)
    {
      :score => node.score,
      :options => []
    }
  end

  def s(*nodes)
    {
      :score => nodes.first.score,
      :options => nodes
    }
  end
end

class ABMinimax
  def initialize(min_score, heuristic_score, depth_limit)
    @min_score_possible = min_score
    @heuristic_score = heuristic_score
    @depth_limit = depth_limit
  end

  attr_reader :min_score_possible, :heuristic_score, :depth_limit

  def evaluate(tree)
    most_beneficial_strategy(tree, depth_limit)[:nodes]
  end

  def most_beneficial_strategy(tree, depth)
    my_best_score = min_score_possible
    best_nodes = []

    tree.childs.each do |child|
      if is_final?(child)
        score = child.score
      elsif depth == 0
        score = heuristic_score
      else
        score = most_damaging_score child, my_best_score, depth-1
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

    return {
      :score => my_best_score,
      :nodes => best_nodes
    }
  end

  def most_damaging_score(child, my_best_score, depth)
    most_damaging_score = nil

    child.childs.each do |grandchild|
      if is_final?(grandchild)
        minimizing_score = grandchild.score
      elsif depth == 0
        minimizing_score = heuristic_score
      else
        res = most_beneficial_strategy grandchild, depth-1
        minimizing_score = res[:score]
      end

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

    most_damaging_score
  end

  def is_final?(tree)
    tree.childs.empty?
  end
end

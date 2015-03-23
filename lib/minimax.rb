class Minimax
  def initialize(state, me, current_player)
    @state = state
    @me = me
    @current_player = current_player
  end

  def score
    state.is_finished?? leaf_score : node_score
  end

  private
  attr_accessor :state, :me, :current_player

  def leaf_score
    case state.winner
    when nil
      0
    when me
      1
    else
      -1
    end
  end

  def node_score
    possibilities = state.available_locations
      .map {|location| choice_score location}

    (me == current_player)? possibilities.max : possibilities.min
  end

  def choice_score(location)
    next_state = state.put(location, current_player)
    next_player = current_player == :X ? :O : :X
    Minimax.new(next_state, me, next_player).score
  end
end

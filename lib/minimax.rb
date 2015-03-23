class Minimax
  def initialize(state, me, current_player)
    @state = state
    @me = me
    @current_player = current_player
  end

  def score
    state.is_finished?? leaf_score : node_score
  end

  def best_options
    if !state.is_finished? && is_my_turn?
      locations_with_best_score
    else
      []
    end
  end

  private
  attr_accessor :state, :me, :current_player

  def is_my_turn?
    current_player == me
  end

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
    possibilities = node_options.map {|option| option[:score]}

    is_my_turn?? possibilities.max : possibilities.min
  end

  def locations_with_best_score
    r = node_options.inject({:score => -1, :locations => []}) {|result, option|
      if option[:score] == result[:score]
        result[:locations] << option[:location]
        result
      elsif option[:score] > result[:score] 
        {:score => option[:score], :locations => [option[:location]]}
      else
        result
      end
    }

    r[:locations]
  end

  def node_options
    state.available_locations.map do |location| 
      {:location => location, :score => location_score(location)}
    end
  end

  def location_score(location)
    next_state = state.put(location, current_player)
    next_player = current_player == :X ? :O : :X
    Minimax.new(next_state, me, next_player).score
  end
end

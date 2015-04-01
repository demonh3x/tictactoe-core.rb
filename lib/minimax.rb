class Minimax
  def initialize(me, opponent, current_player)
    @me = me
    @opponent = opponent
    @current_player = current_player
  end

  def strategies(state)
    @state = state

    score_meanings = {1 => :win, 0 => :draw, -1 => :lose}

    strategies = map_keys(scored_locations, score_meanings)
    add_best(strategies)

    strategies
  end

  protected
  attr_accessor :state

  def score
    state.is_finished?? leaf_score : node_score
  end

  private
  attr_reader :me, :opponent, :current_player

  def map_keys(hash, mappings)
    Hash[hash.map {|k, v| [mappings[k], v] }]
  end

  def add_best(strategies)
    [:win, :draw, :lose].each do |outcome|
      if strategies.has_key? outcome
        strategies[:best] = strategies[outcome] 
        return strategies
      end
    end

    strategies[:best] = []
    strategies
  end

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
    scores = scored_locations.keys
    is_my_turn?? scores.max : scores.min
  end

  def scored_locations
    if state.available_locations.size == 9
      return {0 => state.available_locations}
    end

    node_options.inject({}) do |result, option|
      score = option[:score]
      location = option[:location]

      result[score] ||= []
      result[score] << location
      result
    end
  end

  def node_options
    state.available_locations.map do |location| 
      {:location => location, :score => location_score(location)}
    end
  end

  def location_score(location)
    mm = self.class.new(me, opponent, next_player)
    mm.state = next_state(location)
    mm.score
  end

  def next_state(location)
    state.put(location, current_player)
  end

  def next_player
    is_my_turn?? opponent : me
  end
end

class Game
  def initialize(initial_state)
    @state = initial_state
  end

  attr_accessor :state

  def is_finished?
    state.is_finished?
  end

  def winner
    state.winner
  end

  def make_move(player, location)
    self.state = state.put(location, player)
  end
end

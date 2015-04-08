class Game
  def initialize(state, ui, players)
    @state = state
    @ui = ui
    @turns = players.cycle
  end

  def finished?
    state.when_finished{true} || false
  end

  def start
    update_ui
  end

  def step
    give_turn
    update_ui
  end

  private
  
  attr_accessor :state, :ui, :turns

  def give_turn
    player = turns.next
    self.state = player.play(state)
  end

  def update_ui
    ui.update(state)
  end
end

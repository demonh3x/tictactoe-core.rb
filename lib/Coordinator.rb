class Coordinator
  def initialize(game, ui, players)
    @game = game
    @ui = ui
    @players = players
    @first_step = true
    @turns = @players.cycle
  end

  def finished?
    game.is_finished?
  end

  def step
    raise 'The game is finished!' if finished?

    state = game.state
    first_update_ui(state)
    give_turn(state)

    state = game.state
    update_ui(state)

    announce_winner if finished?
  end

  private
  
  attr_accessor :game, :ui, :players, :first_step, :turns

  def first_update_ui(state)
    if first_step
      update_ui(state)
      self.first_step = false
    end
  end

  def update_ui(state)
    ui.update(state)
  end

  def give_turn(state)
    player = turns.next
    game.make_move(player.ask_for_location(state), player.mark)
  end

  def announce_winner
    winner = game.winner
    ui.announce_result(winner)
  end
end

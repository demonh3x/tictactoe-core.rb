class Coordinator
  def initialize(game, uis, players)
    @game = game
    @uis = uis
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
    first_update_uis(state)
    give_turn(state)

    state = game.state
    update_uis(state)

    announce_winner if finished?
  end

  private
  
  attr_accessor :game, :uis, :players, :first_step, :turns

  def first_update_uis(state)
    if first_step
      update_uis(state)
      self.first_step = false
    end
  end

  def update_uis(state)
    uis.each do |ui|
      ui.update(state)
    end
  end

  def give_turn(state)
    player = turns.next
    game.make_move(player.ask_for_location(state), player.mark)
  end

  def announce_winner
    winner = game.winner
    uis.each do |ui|
      ui.announce_result(winner)
    end
  end
end

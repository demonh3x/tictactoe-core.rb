class Coordinator
  def initialize(game, players)
    @game = game
    @players = players
    @first_step = true
    @turns = @players.cycle
  end

  def finished?
    @game.is_finished?
  end

  def step
    raise 'The game is finished!' if finished?

    first_update_uis
    give_turn
    update_uis
    announce_winner if finished?
  end

  private

  def first_update_uis
    if @first_step
      update_uis 
      @first_step = false
    end
  end

  def update_uis
    state = @game.state
    @players.each do |p|
      p[:ui].update(state)
    end
  end

  def give_turn
    player = @turns.next
    p = player[:player]
    ui = player[:ui]
    @game.make_move(p, ui.ask_for_location)
  end

  def announce_winner
    winner = @game.winner
    @players.each do |p|
      p[:ui].announce_result(winner)
    end
  end
end

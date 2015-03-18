class Game
  def initialize(initial_state)
    @state = initial_state
  end

  def state
    @state
  end

  def is_finished?
    has_winner? || is_full?
  end

  def winner
    @state.board.lines
      .map{|line| player_fully_occupying(line)}
      .select{|mark| mark != nil}
      .first
  end

  def make_move(player, location)
    @state = @state.put(location, player)
  end

  private

  def has_winner?
    winner != nil
  end

  def is_full?
    @state.board.locations
      .map{|location| @state.look_at(location)}
      .select{|mark| mark == nil}
      .empty?
  end

  def player_fully_occupying(line)
    players = line.map {|location| @state.look_at(location)}.uniq
    players.size == 1? players.first : nil
  end
end

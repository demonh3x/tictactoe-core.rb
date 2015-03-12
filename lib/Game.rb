class Game
  def initialize(board)
    @state = {}
    board.locations.each do |l|
      @state[l] = nil
    end
    @board = board
  end

  def state
    @state.clone
  end

  def is_finished?
    has_winner? || is_full?
  end

  def winner
    @board.lines
      .map{|line| player_fully_occupying(line)}
      .select{|p| p != nil}
      .first
  end

  def make_move(player, location)
    @state[location] = player
  end

  private

  def has_winner?
    winner != nil
  end

  def is_full?
    @board.locations
      .map{|l| @state[l]}
      .select{|p| p == nil}
      .empty?
  end

  def player_fully_occupying(line)
    players = line.map {|l| @state[l]}.uniq
    players.size == 1? players.first : nil
  end
end

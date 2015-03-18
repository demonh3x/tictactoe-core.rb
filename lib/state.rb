class State
  def initialize(board, marks=[])
    @board = board
    @marks = marks
  end
  
  def put(location, mark)
    new_marks = marks.clone
    new_marks[location] = mark
    State.new(board, new_marks)
  end

  def look_at(location)
    marks[location]
  end

  def is_full?
    board.locations
      .map{|location| look_at(location)}
      .select{|mark| mark == nil}
      .empty?
  end

  def winner
    board.lines
      .map{|line| player_fully_occupying(line)}
      .select{|mark| mark != nil}
      .first
  end

  attr_reader :board

  private
  attr_reader :marks

  def player_fully_occupying(line)
    players = line.map {|location| look_at(location)}.uniq
    players.size == 1? players.first : nil
  end
end

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

  def is_finished?
    winner != nil || is_full?
  end

  def winner
    marks_occupying_a_full_line.first
  end

  def available_locations
    board.locations.select{|location| look_at(location).nil?}
  end

  private
  attr_reader :board, :marks

  def is_full?
    available_locations.empty?
  end

  def marks_occupying_a_full_line
    board.lines
      .map{|line| mark_fully_occupying(line)}
      .select{|mark| mark != nil}
  end

  def mark_fully_occupying(line)
    marks = line.map {|location| look_at(location)}.uniq
    marks.size == 1? marks.first : nil
  end
end

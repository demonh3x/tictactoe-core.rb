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
    available_locations.empty?
  end

  def winner
    marks_occupying_a_full_line.first
  end

  def available_locations
    board.locations.select{|location| look_at(location).nil?}
  end

  attr_reader :board

  private
  attr_reader :marks

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

class State
  def initialize(board, marks=[])
    @board = board
    @marks = marks
  end
  
  def make_move(location, mark)
    new_marks = marks.clone
    new_marks[location] = mark
    State.new(board, new_marks)
  end

  def is_finished?
    has_winner? || is_full?
  end

  def winner
    marks_occupying_a_full_line.first
  end

  def available_moves
    board.locations.select{|location| marks[location].nil?}
  end

  def layout
    board.locations.map do |location| 
      [location, marks[location]]
    end
  end

  private
  attr_reader :board, :marks

  def has_winner?
    winner != nil
  end

  def is_full?
    available_moves.empty?
  end

  def marks_occupying_a_full_line
    board.lines
      .map{|line| mark_fully_occupying(line)}
      .select{|mark| mark != nil}
  end

  def mark_fully_occupying(line)
    marks_in_line = line.map {|location| marks[location]}.uniq
    marks_in_line.size == 1? marks_in_line.first : nil
  end
end

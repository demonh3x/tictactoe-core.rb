class State
  def initialize(board, marks=[])
    @board = board
    @marks = marks
  end
  
  def available_moves
    @available ||= board.locations.select{|location| marks[location].nil?}
  end

  def make_move(location, mark)
    new_marks = marks.clone
    new_marks[location] = mark
    State.new(board, new_marks)
  end

  def when_finished(&block)
    yield winner if is_finished?
  end

  def layout
    board.locations.map do |location| 
      [location, marks[location]]
    end
  end

  attr_reader :board

  private
  attr_reader :marks

  def is_finished?
    is_full? || has_winner?
  end

  def is_full?
    available_moves.empty?
  end

  def has_winner?
    winner != nil
  end

  def winner
    @winner ||= board.lines
      .map{|line| marks_in line}
      .select{|line_marks| are_the_same? line_marks}
      .map(&:first)
      .select{|mark| !mark.nil?}
      .first
  end

  def marks_in(line)
    line.map{|location| marks[location]}
  end

  def are_the_same?(line_marks)
    line_marks.all?{|m| m == line_marks.first}
  end
end

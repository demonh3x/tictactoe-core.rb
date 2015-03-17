class State
  def initialize(board, marks={})
    @board = board
    @marks = marks
  end
  
  def put(location, mark)
    marks = @marks.clone
    marks[location] = mark
    State.new(@board, marks)
  end

  def look_at(location)
    @marks[location]
  end

  attr_reader :board
end

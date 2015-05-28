module Tictactoe
  class State
    attr_reader :board, :marks

    def initialize(board, marks=[nil] * board.locations.length)
      @board = board
      @marks = marks
    end

    def available_moves
      @available ||= board.locations.select{|location| marks[location].nil?}
    end

    def played_moves
      @played_moves ||= board.locations.length - available_moves.length
    end

    def make_move(location, mark)
      new_marks = marks.clone
      new_marks[location] = mark
      self.class.new(board, new_marks)
    end

    def is_finished?
      is_full? || has_winner?
    end

    def winner
      @winner ||= find_winner
    end

    private
    def is_full?
      available_moves.empty?
    end

    def has_winner?
      winner != nil
    end

    def find_winner
      board.lines.each do |line|
        line_marks = line.map{|location| marks[location]}
        return line_marks.first if line_marks.all?{|mark| mark && mark == line_marks.first}
      end

      nil
    end
  end
end

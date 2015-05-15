module Tictactoe
  class State
    def initialize(board, marks=[nil] * board.locations.length)
      @board = board
      @marks = marks
    end

    def available_moves
      @available ||= board.locations.select{|location| marks[location].nil?}
    end

    def make_move(location, mark)
      new_marks = marks.clone
      new_marks[location] = mark
      self.class.new(board, new_marks)
    end

    def when_finished(&block)
      yield winner if is_finished?
    end

    def layout
      marks
    end

    def ==(other)
      return false if other.class != self.class
      self.marks == other.marks
    end

    attr_reader :board, :marks

    private

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
      @winner ||= find_winner
    end

    def find_winner
      for line in board.lines
        first_mark_in_line = nil
        is_winner = true

        for location in line
          mark = marks[location]
          first_mark_in_line ||= mark

          is_winner = mark != nil && mark == first_mark_in_line
          break if !is_winner
        end

        return first_mark_in_line if is_winner
      end

      nil
    end
  end
end

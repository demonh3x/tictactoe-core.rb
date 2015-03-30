class Cli
  def initialize(output)
    @output = output
  end

  def update(state)
    print_board state
    announce_result state.winner if state.is_finished?
  end

  private

  attr_reader :output

  def announce_result(winner)
    if winner.nil?
      print_draw
    else
      print_winner(winner)
    end
  end

  def print_board(state)
    marks_in_the_board = (0..8).map{|l| get_mark state, l}
    m = marks_in_the_board

    board =
    "+---+---+---+\n" +
    "| #{m[0]} | #{m[1]} | #{m[2]} |\n" +
    "+---+---+---+\n" +
    "| #{m[3]} | #{m[4]} | #{m[5]} |\n" +
    "+---+---+---+\n" +
    "| #{m[6]} | #{m[7]} | #{m[8]} |\n" +
    "+---+---+---+"

    output.puts(board)
  end

  def get_mark(state, loc)
    mark = state.look_at(loc)
    mark == nil ? loc : mark.to_s
  end

  def print_draw
    output.puts "It is a draw."
  end

  def print_winner(winner)
    output.puts "#{winner.to_s} has won!"
  end
end

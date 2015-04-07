class Cli
  def initialize(output)
    @output = output
  end

  def update(state)
    print_board state

    state.when_finished do |winner|
      announce_result winner
    end
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
    cells = get_cells state
    board = format_board cells
    output.puts(board)
  end

  def get_cells(state)
    state.layout.map do |loc, mark|
      (mark || loc).to_s
    end
  end

  def format_board(cells)
    side_size = Math.sqrt(cells.size)
    cells_grouped_by_row = cells.each_slice(side_size).to_a

    rows = cells_grouped_by_row.map {|row_cells| row(row_cells) + "\n" }
    separator = horizontal_separator(side_size) + "\n"

    join_surrounding(rows, separator)
  end

  def row(cells)
    cells_with_fixed_width = cells.map{|cell_text| grow(cell_text, cell_width)}
    join_surrounding(cells_with_fixed_width, "|")
  end

  def horizontal_separator(size)
    cell_line = "-" * cell_width
    cell_lines = [cell_line] * size
    join_surrounding(cell_lines, "+")
  end

  def cell_width
    3
  end

  def grow(text, width)
    while text.length < width
      text = " " + text if text.length < width
      text = text + " " if text.length < width
    end

    text
  end

  def join_surrounding(elements, separator)
    separator + elements.join(separator) + separator
  end

  def print_draw
    output.puts "It is a draw."
  end

  def print_winner(winner)
    output.puts "#{winner.to_s} has won!"
  end
end

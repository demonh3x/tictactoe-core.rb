module UIs
  class Cli
    def initialize(output)
      @output = output
    end

    def update(state)
      output.puts representation_of state

      state.when_finished do |winner|
        output.puts announcement_of winner
      end
    end

    private

    attr_reader :output

    def announcement_of(winner)
      winner.nil?? "It is a draw." : "#{winner.to_s} has won!"
    end

    def representation_of(state)
      format_board get_cells state
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
  end
end

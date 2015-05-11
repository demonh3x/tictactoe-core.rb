module Tictactoe
  module Cli
    class BoardFormatter
      def format(marks)
        format_board(get_cells(marks))
      end

      private
      def get_cells(marks)
        cells = []
        marks.each_with_index do |mark, index|
          cell = (mark || index).to_s
          cells.push(cell)
        end
        cells
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
end

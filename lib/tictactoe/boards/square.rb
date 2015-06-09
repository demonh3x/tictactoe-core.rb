module Tictactoe
  module Boards
    class Square
      def initialize(side_size)
        self.side_size = side_size
      end

      def locations
        @locations ||= (0..(side_size * side_size) -1).to_a
      end

      def lines
        @lines ||= horizontal_lines + vertical_lines + diagonal_lines
      end

      private
      attr_accessor :side_size

      def horizontal_lines
        locations.each_slice(side_size).to_a
      end

      def vertical_lines
        horizontal_lines.transpose
      end

      def diagonal_lines
        descending = (0..side_size - 1).map do |column|
          column * (side_size + 1)
        end
        ascending = (1..side_size).map do |column|
          column * (side_size - 1)
        end

        [descending, ascending]
      end
    end
  end
end

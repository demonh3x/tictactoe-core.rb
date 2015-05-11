module Tictactoe
  module Boards
    class ThreeByThreeBoard
      LOCATIONS = [0, 1, 2, 3, 4, 5, 6, 7, 8]

      HORIZONTAL_LINES = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
      ]
      VERTICAL_LINES = HORIZONTAL_LINES.transpose
      DIAGONALS = [
        [0, 4, 8],
        [2, 4, 6],
      ]
      LINES = HORIZONTAL_LINES + VERTICAL_LINES + DIAGONALS

      def locations
        LOCATIONS
      end

      def lines
        LINES
      end
    end
  end
end

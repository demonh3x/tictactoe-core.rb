module Boards
  class FourByFourBoard
    LOCATIONS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    HORIZONTAL_LINES = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15],
    ]
    VERTICAL_LINES = HORIZONTAL_LINES.transpose
    DIAGONALS = [
      [0, 5, 10, 15],
      [3, 6, 9, 12],
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

class ThreeByThreeBoard
  def initialize
    @locations = [0, 1, 2, 3, 4, 5, 6, 7, 8]

    horizontal = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    vertical = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
    diagonals = [[0, 4, 8], [2, 4, 6]]
    @lines = horizontal + vertical + diagonals
  end

  def locations
    @locations
  end

  def lines
    @lines
  end
end

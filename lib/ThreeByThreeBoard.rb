require 'Location.rb'

class ThreeByThreeBoard
  def initialize
    @locations = (0..2).flat_map{|x| 
      (0..2).flat_map{|y|
        Location.new(x, y)}}

    horizontal = (0..2).map{|x| 
      (0..2).flat_map{|y|
        Location.new(x, y)}}

    vertical = (0..2).map{|x|
      (0..2).flat_map{|y|
        Location.new(y, x)}}

    diagonals = [
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]]
    ].map{|d|
      d.map{|xy|
        x = xy[0]
        y = xy[1]
        Location.new(x, y)
      }
    }

    @lines = horizontal + vertical + diagonals
  end

  def locations
    @locations
  end

  def lines
    @lines
  end
end

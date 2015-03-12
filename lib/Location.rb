class Location
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    return self.class == other.class &&
      self.x == other.x &&
      self.y == other.y
  end

  alias_method :eql?, :==

  def hash
    self.x.hash * self.y.hash
  end
end

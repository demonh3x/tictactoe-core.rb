class Game
  def initialize(initial_state)
    @state = {}
  end
  def state()
    @state
  end
  def finished?()
    false
  end
  def winner()
  end
  def make_move(player, location)
    @state[location] = player
  end
end

class Player
end

class Location
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    return self.class == other.class && self.x == other.x && self.y == other.y
  end
  alias_method :eql?, :==

  def hash()
    self.x * self.y
  end
end

describe "Location" do
  it "Should equal other location that has the same coordinates" do
    expect(Location.new(1, 2) == Location.new(1, 2)).to eq(true)
  end

  it "Should not equal to other location with different coordinates" do
    expect(Location.new(1, 2) == Location.new(2, 2)).to eq(false)
  end

  it "Should not equal to other non-location objects" do
    expect(Location.new(1, 2) == "1, 2").to eq(false)
  end

  it "Should be usable as a hash key" do
    hash = {Location.new(1, 2) => "::associated_value::"}
    expect(hash.key? Location.new(1, 2)).to eq(true)
    expect(hash[Location.new(1, 2)]).to eq("::associated_value::")
  end
end

describe "Game" do
  def loc(x, y)
    Location.new(x, y)
  end

  before(:each) do
    @empty_state = {}
    @game = Game.new(@empty_state)
    @x = Player.new
    @o = Player.new
  end

  describe "With no moves" do
    it "Should have the same state" do
      expect(@game.state).to eq(@empty_state)
    end

    it "Should have no winner" do
      expect(@game.finished?).to eq(false)
      expect(@game.winner).to eq(nil)
    end
  end

  describe "With the first move" do
    before(:each) do
      @game.make_move(@x, loc(0,0))
    end

    it "The state should contain that move" do
      expect(@game.state).to eq({loc(0,0) => @x})
    end
  end

  describe "With three moves for x" do
    before(:each) do
      @game.make_move(@x, loc(0,0))
      @game.make_move(@x, loc(0,1))
      @game.make_move(@x, loc(0,2))
    end

    it "Should have won" do
      expect(@game.finished?).to eq(true)
      expect(@game.winner).to eq(@x)
    end
  end
end

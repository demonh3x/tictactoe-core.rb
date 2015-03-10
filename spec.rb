class Game
  def initialize(initial_state)
    @state = {}
  end
  def state()
    @state
  end
  def finished?()
    winner() != nil
  end
  def winner()
    line = [xy(0, 0), xy(0, 1), xy(0, 2)]
    players = line.map {|l| @state[l]}.uniq
    players.size == 1? players.first : nil
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
    self.x.hash * self.y.hash
  end
end

class ThreeByThreeBoard
  def location(x, y)
    Location.new(x, y)
  end
end

def xy(x, y)
  ThreeByThreeBoard.new.location(x, y)
end

describe "Location" do
  it "Should equal other location that has the same coordinates" do
    expect(xy(1, 2) == xy(1, 2)).to eq(true)
  end

  it "Should not equal to other location with different coordinates" do
    expect(xy(1, 2) == xy(2, 2)).to eq(false)
  end

  it "Should not equal to other non-location objects" do
    expect(xy(1, 2) == "1, 2").to eq(false)
  end

  it "Should be usable as a hash key" do
    hash = {xy(1, 2) => "::associated_value::"}
    expect(hash.key? xy(1, 2)).to eq(true)
    expect(hash[xy(1, 2)]).to eq("::associated_value::")
  end
end

describe "Game" do
  before(:each) do
    @empty_state = {}
    @game = Game.new(@empty_state)
    @a = Player.new
    @b = Player.new
  end

  describe "With no moves" do
    it "Should have the same state" do
      expect(@game.state).to eq(@empty_state)
    end

    it "The game should not be finished" do 
      expect(@game.finished?).to eq(false)
    end

    it "Should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end

  describe "With the first move" do
    before(:each) do
      @game.make_move(@a, xy(0,0))
    end

    it "The state should contain that move" do
      expect(@game.state).to eq({xy(0,0) => @a})
    end
  end

  [
    [xy(0,0), xy(0,1), xy(0,2)],
    #[xy(0,0), xy(1,0), xy(2,0)],
    #[xy(0,0), xy(1,1), xy(2,2)],
  ].each do |line|
    describe "With a line for player a" do
      before(:each) do
        line.each do |l|
          @game.make_move(@a, l)
        end
      end

      it "The game should be finished" do
        expect(@game.finished?).to eq(true)
      end

      it "Should have won" do
        expect(@game.winner).to eq(@a)
      end
    end
  end
  
  describe "With three moves not in line for player a" do
    before(:each) do
      [xy(0,0), xy(0,1), xy(1,0)].each do |l|
        @game.make_move(@a, l)
      end
    end
    
    it "The game should not be finished" do 
      expect(@game.finished?).to eq(false)
    end

    it "Should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end
end

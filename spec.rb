class Game
  def initialize(board)
    @state = {}
    board.locations.each do |l|
      @state[l] = nil
    end
    @board = board
  end

  def state
    @state.clone
  end

  def is_finished?
    has_winner? || is_full?
  end

  def winner
    @board.lines
      .map{|line| player_fully_occupying(line)}
      .select{|p| p != nil}
      .first
  end

  def make_move(player, location)
    @state[location] = player
  end

  private

  def has_winner?
    winner != nil
  end

  def is_full?
    @board.locations
      .map{|l| @state[l]}
      .select{|p| p == nil}
      .empty?
  end

  def player_fully_occupying(line)
    players = line.map {|l| @state[l]}.uniq
    players.size == 1? players.first : nil
  end
end

class Player
end

class BidimensionalLocation
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

class ThreeByThreeBoard
  def initialize
    @locations = (0..2).flat_map{|x| 
      (0..2).flat_map{|y|
        BidimensionalLocation.new(x, y)}}

    horizontal = (0..2).map{|x| 
      (0..2).flat_map{|y|
        BidimensionalLocation.new(x, y)}}

    vertical = (0..2).map{|x|
      (0..2).flat_map{|y|
        BidimensionalLocation.new(y, x)}}

    diagonals = [
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]]
    ].map{|d|
      d.map{|xy|
        x = xy[0]
        y = xy[1]
        BidimensionalLocation.new(x, y)
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

def xy(x, y)
  BidimensionalLocation.new(x, y)
end

describe "Location" do
  it "should equal other location that has the same coordinates" do
    expect(xy(1, 2) == xy(1, 2)).to eq(true)
  end

  it "should not equal to other location with different coordinates" do
    expect(xy(1, 2) == xy(2, 2)).to eq(false)
  end

  it "should not equal to other non-location objects" do
    expect(xy(1, 2) == "1, 2").to eq(false)
  end

  it "should be usable as a hash key" do
    hash = {xy(1, 2) => "::associated_value::"}
    expect(hash.key? xy(1, 2)).to eq(true)
    expect(hash[xy(1, 2)]).to eq("::associated_value::")
  end
end

describe "3x3 board" do
  before(:each) do
    @board = ThreeByThreeBoard.new
  end

  it "should know the available locations" do
    expect(@board.locations).to eq([
      xy(0, 0), xy(0, 1), xy(0, 2),
      xy(1, 0), xy(1, 1), xy(1, 2),
      xy(2, 0), xy(2, 1), xy(2, 2)
    ])
  end

  it "should know the lines" do
    expected_lines = [
      [xy(0, 0), xy(0, 1), xy(0, 2)],
      [xy(1, 0), xy(1, 1), xy(1, 2)],
      [xy(2, 0), xy(2, 1), xy(2, 2)],

      [xy(0, 0), xy(1, 0), xy(2, 0)],
      [xy(0, 1), xy(1, 1), xy(2, 1)],
      [xy(0, 2), xy(1, 2), xy(2, 2)],

      [xy(0, 0), xy(1, 1), xy(2, 2)],
      [xy(0, 2), xy(1, 1), xy(2, 0)],
    ]
    actual_lines = @board.lines

    expect(actual_lines).to match_array(expected_lines)
  end
end

def state(
  x0y0, x1y0, x2y0,
  x0y1, x1y1, x2y1,
  x0y2, x1y2, x2y2)
  {
    xy(0, 0) => x0y0,
    xy(1, 0) => x1y0,
    xy(2, 0) => x2y0,
    xy(0, 1) => x0y1,
    xy(1, 1) => x1y1,
    xy(2, 1) => x2y1,
    xy(0, 2) => x0y2,
    xy(1, 2) => x1y2,
    xy(2, 2) => x2y2,
  }
end

describe "Game" do
  before(:each) do
    @board = ThreeByThreeBoard.new
    @game = Game.new(@board)
    @X = Player.new
    @O = Player.new
  end

  it "should avoid leaking state mutations" do
    @game.state[xy(0, 0)] = @X
    expect(@game.state[xy(0, 0)]).to eq(nil)
  end

  describe "with no moves" do
    it "should have an empty state" do
      expect(@game.state).to eq({
        xy(0, 0) => nil,  
        xy(0, 1) => nil,  
        xy(0, 2) => nil,  
        xy(1, 0) => nil,  
        xy(1, 1) => nil,  
        xy(1, 2) => nil,  
        xy(2, 0) => nil,  
        xy(2, 1) => nil,  
        xy(2, 2) => nil,  
      })
    end

    it "the game should not be finished" do
      expect(@game.is_finished?).to eq(false)
    end

    it "should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end

  describe "with the first move" do
    before(:each) do
      @loc = xy(0, 0)
      @game.make_move(@X, @loc)
    end

    it "the state should contain that move" do
      expect(@game.state[@loc]).to eq(@X)
    end
  end

  ThreeByThreeBoard.new.lines.each do |line|
    describe "with a line for player a" do
      before(:each) do
        line.each do |l|
          @game.make_move(@X, l)
        end
      end

      it "the game should be finished" do
        expect(@game.is_finished?).to eq(true)
      end

      it "should have won" do
        expect(@game.winner).to eq(@X)
      end
    end
  end
  
  def set_state(
    x0y0, x1y0, x2y0,
    x0y1, x1y1, x2y1,
    x0y2, x1y2, x2y2)
    state(
      x0y0, x1y0, x2y0,
      x0y1, x1y1, x2y1,
      x0y2, x1y2, x2y2
    ).each do |l, p|
      @game.make_move(p, l)
    end
  end

  describe "with three moves not in line for player a" do
    before(:each) do
      set_state(
        @X,  @X,  nil,
        @X,  nil, nil,
        nil, nil, nil
      )
    end
    
    it "the game should not be finished" do
      expect(@game.is_finished?).to eq(false)
    end

    it "should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end

  describe "with a full board but no winner" do
    before(:each) do
      set_state(
        @O, @X, @X,
        @X, @X, @O,
        @O, @O, @X
      )
    end

    it "the game should be finished" do
      expect(@game.is_finished?).to eq(true)
    end

    it "should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end
end

class Cli
  def initialize(input, output, player_icons)
    @input = input
    @output = output
    @player_icons = player_icons
  end

  def update(state)
    @output.puts("  x 0   1   2")
    @output.puts("y +---+---+---+")
    (0..2).each do |y|
      @output.puts(
        "#{y} | #{get_icon(state, 0, y)} | #{get_icon(state, 1, y)} | #{get_icon(state, 2, y)} |\n" +
        "  +---+---+---+"
      )
    end
  end

  def give_turn
    @output.puts "Your turn! Where do you want to play? (format: x,y)"
    parts = read_ints
    return nil if parts.nil?
    x = parts[0]
    y = parts[1]
    BidimensionalLocation.new(x, y)
  end

  private

  def get_icon(state, x, y)
    player = state[BidimensionalLocation.new(x, y)]
    icon = @player_icons[player]
    icon == nil ? ' ' : icon
  end

  def read_ints
    i = read_input
    return nil if i.nil?
    while !is_valid?(i)
      @output.puts "Don't understand \"#{i[:str]}\". Please, make sure you use the format \"x,y\""
      i = read_input
    end

    i[:parts]
  end

  def read_input
      str = @input.gets
      return nil if str.nil?
      {
        :str => str.strip,
        :parts => str.split(',').map{|s| Integer(s.strip) rescue nil}
      }
  end

  def is_valid?(input)
    !input[:parts].any?{|p| p.nil?}
  end
end

describe "CLI" do
  before(:each) do
    @X = Player.new
    @O = Player.new
    @in = StringIO.new
    @out = StringIO.new
    @icons = {@X => 'X', @O => 'O'}
    @cli = Cli.new(@in, @out, @icons)
  end

  describe "when updating" do
    describe "given an empty state" do
      it "prints it without pieces" do
        @cli.update(state(
          nil, nil, nil,
          nil, nil, nil,
          nil, nil, nil,
        ))
        expect(@out.string).to eq(
          "  x 0   1   2\n" +
          "y +---+---+---+\n" +
          "0 |   |   |   |\n" +
          "  +---+---+---+\n" +
          "1 |   |   |   |\n" +
          "  +---+---+---+\n" +
          "2 |   |   |   |\n" +
          "  +---+---+---+\n"
        )
      end
    end

    describe "given a state with some moves" do
      it "prints it with the pieces at the correct position" do
        @cli.update(state(
          @X,  nil, @O,
          nil, @O,  @X,
          nil, nil, nil,
        ))
        expect(@out.string).to eq(
          "  x 0   1   2\n" +
          "y +---+---+---+\n" +
          "0 | X |   | O |\n" +
          "  +---+---+---+\n" +
          "1 |   | O | X |\n" +
          "  +---+---+---+\n" +
          "2 |   |   |   |\n" +
          "  +---+---+---+\n"
        )
      end
    end
  end

  def human_will_send(str)
    @in.string += "#{str}\n"
  end

  describe "when giving turn" do
    it "asks for a location" do
      human_will_send("1,2")
      @cli.give_turn
      expect(@out.string).to include("Your turn! Where do you want to play? (format: x,y)\n")
    end

    describe "given no input" do
      it "returns nil" do
        expect(@cli.give_turn).to eq(nil)
      end
    end

    describe "given an input with no whitespaces" do
      it "reads the location" do
        human_will_send("1,2")
        expect(@cli.give_turn).to eq(xy(1, 2))
      end
    end

    describe "given an input with some whitespaces" do
      it "reads the location" do
        human_will_send("  \t 2 ,\t 0 ")
        expect(@cli.give_turn).to eq(xy(2, 0))
      end
    end

    describe "given an invalid input" do
      it "should try to read again" do
        human_will_send("::invalid_input::")
        human_will_send("1, 1")
        expect(@cli.give_turn).to eq(xy(1, 1))
        expect(@out.string).to include("Don't understand \"::invalid_input::\". Please, make sure you use the format \"x,y\"\n")
      end
    end
  end
end

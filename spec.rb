def next_state(state, location, player) 
  throw Error if state[location] != nil

  s = state.clone
  s[location] = player
  s
end

describe "Next state" do
  describe "Given empty state" do
    before(:each) do
      @empty_state = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    end

    it "Does not modify the input state" do
      next_state(@empty_state, 0, 'X')
      expect(@empty_state).to eq([nil, nil, nil, nil, nil, nil, nil, nil, nil]) 
    end

    it "When the player plays at an already played location raises error" do
      expect{next_state(['X', nil, nil, nil, nil, nil, nil, nil, nil], 0, 'X')}.to raise_error
    end

    it "When the player plays to the first location, he should be in that location" do
      expect(next_state(@empty_state, 0, 'X')).to eq(['X', nil, nil, nil, nil, nil, nil, nil, nil])
    end

    it "When the player plays to the second location, he should be in that location" do
      expect(next_state(@empty_state, 1, 'O')).to eq([nil, 'O', nil, nil, nil, nil, nil, nil, nil])
    end

  end
end

class Game 
  def initialize(initial_state, players)
    raise Error if (players.size != 2 || initial_state.size != 9) 
    @state = initial_state
    @players = players
  end
  def advance()
    p = @players.cycle.peek
    player = p[1]
    icon = p[0]
    @state = next_state(@state, player.play, icon) 
  end
  def state()
    @state
  end
end

describe "Game" do
  before(:each) do
    @empty_state = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    @players = {'X' => double("player"), 'O' => double("player")}
  end

  it "Given invalid amount of players raises error" do
    expect {Game.new(@empty_state, {'X' => double("player")})}.to raise_error
    expect {Game.new(@empty_state, {'X' => double("player"), 'O' => double("player"), 'H' => double("player")})}.to raise_error
  end

  it "Given an invalid initial state raises error" do
    expect {Game.new([nil, nil, nil, nil, nil, nil, nil, nil], @players)}.to raise_error
    expect {Game.new([nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], @players)}.to raise_error
  end

  it "Initial state" do
    game = Game.new(@empty_state, @players)
    expect(game.state).to eq(@empty_state)
  end
  
  def first_play_test(player_icon, location, expected_state)
    allow(@players[player_icon]).to receive(:play).and_return(location)
    game = Game.new(@empty_state, @players)

    game.advance()
    expect(game.state).to eq(expected_state)
  end

  it "Advances asking the first player" do
    first_play_test('X', 0, ['X', nil, nil, nil, nil, nil, nil, nil, nil])
    first_play_test('X', 1, [nil, 'X', nil, nil, nil, nil, nil, nil, nil])
  end
end

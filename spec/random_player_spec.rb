require 'state'
require 'random_player'

RSpec.describe "Random player" do
  it "has a mark" do
    player = RandomPlayer.new(:mark, nil)
    expect(player.mark).to eq(:mark)
  end

  describe "given only one possibility" do
    before(:each) do
      @random_player = RandomPlayer.new(:mark, spy("random", :rand => 0.9))
      @state = State.new(spy("board", :locations => [0, 1, 2]))
      @state = @state.put(0, :player_x)
      @state = @state.put(1, :player_x)
    end

    it "should return that one" do
      loc = @random_player.ask_for_location(@state)
      expect(loc).to eq 2
    end
  end

  describe "given two possibilities" do
    before(:each) do
      @state = State.new(spy("board", :locations => [0, 1, 2]))
      @state = @state.put(0, :player_x)
    end

    it "if the random selects the first location, returns it" do
      @random_player = RandomPlayer.new(:mark, spy("random", :rand => 0.0))
      loc = @random_player.ask_for_location(@state)
      expect(loc).to eq 1
    end

    it "if the random selects the second location, returns it" do
      @random_player = RandomPlayer.new(:mark, spy("random", :rand => 0.999))
      loc = @random_player.ask_for_location(@state)
      expect(loc).to eq 2
    end
  end
end

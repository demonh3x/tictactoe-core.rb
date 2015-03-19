require 'state'

RSpec.describe "Random player" do
  class BoardStub
    def locations
      [0, 1, 2]
    end
  end

  class RandomStub
    def initialize(*values_to_return)
      @random_values = *values_to_return
    end

    def rand
      @random_values.pop
    end
  end

  it "has a mark" do
    player = RandomPlayer.new(:mark, RandomStub.new)
    expect(player.mark).to eq(:mark)
  end

  describe "given only one possibility" do
    before(:each) do
      @random_player = RandomPlayer.new(:mark, RandomStub.new(0.9))
      @state = State.new(BoardStub.new)
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
      @state = State.new(BoardStub.new)
      @state = @state.put(0, :player_x)
    end

    it "if the random selects the first location, returns it" do
      @random_player = RandomPlayer.new(:mark, RandomStub.new(0.0))
      loc = @random_player.ask_for_location(@state)
      expect(loc).to eq 1
    end

    it "if the random selects the second location, returns it" do
      @random_player = RandomPlayer.new(:mark, RandomStub.new(0.999))
      loc = @random_player.ask_for_location(@state)
      expect(loc).to eq 2
    end
  end
end

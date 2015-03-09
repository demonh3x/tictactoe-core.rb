def next_state(state, player) 
  state[player.play()] = player
  state
end

describe "Next state" do
  describe "Given empty state" do
    before(:each) do
      @empty_state = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    end
    
    it "When the player plays to the first location, he should be in that location" do
      player = Object.new
      def player.play()
        0
      end
      expect(next_state(@empty_state, player)).to eq([player, nil, nil, nil, nil, nil, nil, nil, nil])
    end

    it "When the player plays to the second location, he should be in that location" do
      player = Object.new
      def player.play()
        1
      end
      expect(next_state(@empty_state, player)).to eq([nil, player, nil, nil, nil, nil, nil, nil, nil])
    end
  end
end

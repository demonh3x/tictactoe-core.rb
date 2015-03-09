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

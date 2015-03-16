RSpec.describe "Game state" do
  it "can look at a location" do
    initial_state = State.new(:board, {})
    next_state = initial_state.put(:location, :mark)
    expect(next_state.look_at(:location)).to eq(:mark)
  end

  it "is immutable" do
    initial_state = State.new(:board, {})
    next_state = initial_state.put(:location, :mark)
    expect(initial_state.look_at(:location)).to eq(nil)
  end

  it "should have a board" do
    s = State.new(:board, {})
    expect(s.board).to eq(:board)
  end
end

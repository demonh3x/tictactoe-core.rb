require 'state'

RSpec.describe "Game state" do
  it "can look at a location" do
    initial_state = State.new(:board)
    next_state = initial_state.put(3, :mark)
    expect(next_state.look_at(3)).to eq(:mark)
  end

  it "is immutable" do
    initial_state = State.new(:board)
    next_state = initial_state.put(2, :mark)
    expect(initial_state.look_at(2)).to eq(nil)
  end
end

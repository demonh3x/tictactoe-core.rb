require 'location'
require 'three_by_three_board'

RSpec.describe "3x3 board" do
  before(:each) do
    @board = ThreeByThreeBoard.new
  end

  it "should know the available locations" do
    expect(@board.locations).to eq([
      Location.new(0, 0), Location.new(0, 1), Location.new(0, 2),
      Location.new(1, 0), Location.new(1, 1), Location.new(1, 2),
      Location.new(2, 0), Location.new(2, 1), Location.new(2, 2)
    ])
  end

  it "should know the lines" do
    expected_lines = [
      [Location.new(0, 0), Location.new(0, 1), Location.new(0, 2)],
      [Location.new(1, 0), Location.new(1, 1), Location.new(1, 2)],
      [Location.new(2, 0), Location.new(2, 1), Location.new(2, 2)],

      [Location.new(0, 0), Location.new(1, 0), Location.new(2, 0)],
      [Location.new(0, 1), Location.new(1, 1), Location.new(2, 1)],
      [Location.new(0, 2), Location.new(1, 2), Location.new(2, 2)],

      [Location.new(0, 0), Location.new(1, 1), Location.new(2, 2)],
      [Location.new(0, 2), Location.new(1, 1), Location.new(2, 0)],
    ]
    actual_lines = @board.lines

    expect(actual_lines).to match_array(expected_lines)
  end
end

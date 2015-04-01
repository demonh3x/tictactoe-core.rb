require 'boards/three_by_three_board'

RSpec.describe "3x3 board" do
  before(:each) do
    @board = ThreeByThreeBoard.new
  end

  it "should know the available locations" do
    expect(@board.locations).to eq([0, 1, 2, 3, 4, 5, 6, 7, 8])
  end

  it "should know the lines" do
    expected_lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],

      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],

      [0, 4, 8],
      [2, 4, 6],
    ]
    actual_lines = @board.lines

    expect(actual_lines).to match_array(expected_lines)
  end
end

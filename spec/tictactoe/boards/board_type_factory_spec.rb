require 'spec_helper'
require 'tictactoe/boards/square'

RSpec.describe Tictactoe::Boards::Square do
  def create(side_size)
    described_class.new(side_size)
  end

  describe 'given size 3' do
    let(:board) { create(3) }

    it "should know the available locations" do
      expect(board.locations).to eq([0, 1, 2, 3, 4, 5, 6, 7, 8])
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
      actual_lines = board.lines

      expect(actual_lines).to match_array(expected_lines)
    end
  end

  describe 'given size 4' do
    let(:board) { create(4) }

    it 'has the possible locations' do
      expect(board.locations).to eq([
        0, 1, 2, 3,
        4, 5, 6, 7,
        8, 9, 10, 11,
        12, 13, 14, 15
      ])
    end

    it 'should know the lines' do
      expect(board.lines).to eq([
        [0, 1, 2, 3],
        [4, 5, 6, 7],
        [8, 9, 10, 11],
        [12, 13, 14, 15],

        [0, 4, 8, 12],
        [1, 5, 9, 13],
        [2, 6, 10, 14],
        [3, 7, 11, 15],

        [0, 5, 10, 15],
        [3, 6, 9, 12]
      ])
    end
  end
end

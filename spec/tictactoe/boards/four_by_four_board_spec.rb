require 'spec_helper'
require 'tictactoe/boards/four_by_four_board'

RSpec.describe Tictactoe::Boards::FourByFourBoard do
   it 'has the possible locations' do
     expect(described_class.new.locations).to eq([
       0, 1, 2, 3,
       4, 5, 6, 7,
       8, 9, 10, 11,
       12, 13, 14, 15
     ])
   end

   it 'should know the lines' do
     expect(described_class.new.lines).to eq([
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

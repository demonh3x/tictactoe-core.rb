require 'spec_helper'
require 'boards/four_by_four_board'

RSpec.describe "4x4 board" do
   it 'has the possible locations' do
     expect(Boards::FourByFourBoard.new.locations).to eq([
       0, 1, 2, 3,
       4, 5, 6, 7,
       8, 9, 10, 11,
       12, 13, 14, 15
     ])
   end

   it 'should know the lines' do
     expect(Boards::FourByFourBoard.new.lines).to eq([
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

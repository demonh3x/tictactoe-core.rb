require 'tictactoe/boards/three_by_three_board'
require 'tictactoe/boards/four_by_four_board'

module Tictactoe
  module Boards
    class BoardTypeFactory
      def create(side_size)
        case side_size
        when 3 then Tictactoe::Boards::ThreeByThreeBoard.new
        when 4 then Tictactoe::Boards::FourByFourBoard.new
        end
      end
    end
  end
end

module Tictactoe
  module Players
    class Human
      attr_reader :mark

      def initialize(mark, moves_source)
        @mark = mark
        @moves_source = moves_source
      end

      def get_move(state)
        moves_source.get_move!
      end

      private
      attr_reader :moves_source
    end
  end
end

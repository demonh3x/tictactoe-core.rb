module Tictactoe
  module Players
    class Computer
      attr_reader :mark

      def initialize(mark, intelligence, chooser)
        @intelligence = intelligence
        @chooser = chooser
        @mark = mark
      end

      def get_move(state)
        moves = intelligence.desired_moves(state, mark)
        chooser.choose_one(moves)
      end

      def ready_to_move?
        true
      end

      private
      attr_reader :intelligence, :chooser
    end
  end
end

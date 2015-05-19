module Tictactoe
  module Ai
    class ComputerPlayer
      attr_accessor :intelligence, :chooser

      def initialize(intelligence, chooser)
        @intelligence = intelligence
        @chooser = chooser
      end

      def get_move(state)
        chooser.choose_one(intelligence.desired_moves(state))
      end
    end
  end
end

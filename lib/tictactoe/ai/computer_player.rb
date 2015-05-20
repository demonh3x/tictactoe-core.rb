module Tictactoe
  module Ai
    class ComputerPlayer
      attr_accessor :player, :intelligence, :chooser

      def initialize(player, intelligence, chooser)
        @player = player
        @intelligence = intelligence
        @chooser = chooser
      end

      def get_move(state)
        chooser.choose_one(intelligence.desired_moves(state, player))
      end
    end
  end
end

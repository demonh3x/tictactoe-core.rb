require 'tictactoe/ai/intelligence'

module Tictactoe
  module Ai
    class PerfectPlayer
      attr_accessor :player, :state

      def initialize(player, chooser)
        @player = player
        @chooser = chooser
      end

      def update(state)
        self.state = state
      end

      def play_location
        @chooser.choose_one(desired_moves)
      end

      private
      def desired_moves
        Intelligence.new(player).desired_moves(state)
      end
    end
  end
end

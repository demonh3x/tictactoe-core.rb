require 'tictactoe/ai/intelligence'

module Tictactoe
  module Ai
    class PerfectPlayer
      attr_accessor :mark, :state

      def initialize(mark, chooser)
        @mark = mark
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
        Intelligence.new(mark).desired_moves(state)
      end
    end
  end
end

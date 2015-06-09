require 'tictactoe/players/computer'
require 'tictactoe/ai/perfect_intelligence'
require 'tictactoe/ai/random_chooser'

module Tictactoe
  module Players
    class PerfectComputer
      def initialize(mark, random = Random.new)
        intelligence = Tictactoe::Ai::PerfectIntelligence.new
        chooser = Tictactoe::Ai::RandomChooser.new(random)
        self.player = Tictactoe::Players::Computer.new(mark, intelligence, chooser)
      end

      def get_move(state)
        player.get_move(state)
      end

      def mark
        player.mark
      end

      private
      attr_accessor :player
    end
  end
end

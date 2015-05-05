require 'uis/cli/board_formatter'

module UIs
  module Cli
    class Cli
      def initialize(output)
        @output = output
      end

      def update(state)
        output.puts representation_of state

        state.when_finished do |winner|
          output.puts announcement_of winner
        end
      end

      private

      attr_reader :output

      def announcement_of(winner)
        winner.nil?? "It is a draw." : "#{winner.to_s} has won!"
      end

      def representation_of(state)
        marks = state.layout.map {|loc, mark| mark}
        BoardFormatter.new.format(marks)
      end
    end
  end
end

require 'players/cli_player'
require 'players/ai/perfect_player'

module Players
  class PlayersFactory
    def initialize(input, output, random)
      @input = input
      @output = output
      @random = random
    end

    def create(types)
      (types.zip MARKS).map do |type, mark|
        constructors(type, mark)
      end
    end

    private
    attr_reader :input, :output, :random

    MARKS = [:x, :o]
    
    def constructors(type, mark)
      case type
      when :human
        Players::CliPlayer.new(mark, input, output)
      when :computer
        Players::AI::PerfectPlayer.new(
          mark, 
          opponent(mark),
          Players::AI::RandomChooser.new(random)
        )
      end
    end

    def opponent(mark)
      next_mark_index = (MARKS.index(mark) +1) % MARKS.length
      MARKS[next_mark_index]
    end
  end
end

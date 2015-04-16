require 'players/ai/random_strategy_player'
require 'players/cli_player'
require 'players/ai/perfect_player'

class PlayersFactory
  def initialize(input, output, random)
    @input = input
    @output = output
    @random = random
  end

  def create(types)
    (types.zip marks).map do |type, mark|
      constructors[type].call(mark)
    end
  end

  private
  attr_reader :input, :output, :random

  MARKS = [:x, :o]
  def marks
    MARKS
  end

  def constructors
    @constructors ||= {
      :human => lambda do |mark|
        CliPlayer.new(mark, input, output)
      end,
      :computer => lambda do |mark|
        Players::AI::RandomStrategyPlayer.new(
          mark, 
          Players::AI::PerfectPlayer.new(mark, opponent(mark)),
          random
        )
      end
    }
  end

  def opponent(mark)
    next_mark_index = (marks.index(mark) +1) % marks.length
    marks[next_mark_index]
  end
end

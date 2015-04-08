require 'players/ai/random_strategy_player'
require 'players/ai/minimax'
require 'players/play_behaviour'

class PerfectPlayer < RandomStrategyPlayer
  include PlayBehaviour

  def initialize(my_mark, opponents_mark, random)
    strategy = lambda do |state|
      Minimax.new(my_mark, opponents_mark, my_mark).strategies(state)[:best]
    end

    super(my_mark, strategy, random)
  end
end

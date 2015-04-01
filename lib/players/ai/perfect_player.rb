require 'random_strategy_player'
require 'minimax'

class PerfectPlayer < RandomStrategyPlayer
  def initialize(my_mark, opponents_mark, random)
    strategy = lambda do |state|
      Minimax.new(my_mark, opponents_mark, my_mark).strategies(state)[:best]
    end

    super(my_mark, strategy, random)
  end
end

require 'fixed_strategy_player'
require 'minimax'

class PerfectPlayer < FixedStrategyPlayer
  def initialize(my_mark, opponents_mark)
    strategy = lambda do |state|
      Minimax.new(my_mark, opponents_mark, my_mark).strategies(state)[:best]
    end

    super(my_mark, strategy)
  end
end

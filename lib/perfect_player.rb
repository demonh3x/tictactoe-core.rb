require 'minimax'

class PerfectPlayer < FixedStrategyPlayer
  def initialize(my_mark, opponents_mark)
    strategy = lambda do |state|
      Minimax.new(state, my_mark, opponents_mark, my_mark).best_options
    end

    super(my_mark, strategy)
  end
end

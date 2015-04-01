class FixedStrategyPlayer
  def initialize(mark, strategy)
    @mark = mark
    @strategy = strategy
  end

  def ask_for_location(state)
    strategy.call(state).first
  end

  attr_reader :mark

  private
  attr_reader :strategy
end


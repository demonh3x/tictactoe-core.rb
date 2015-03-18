class RandomPlayer
  attr_reader :mark

  def initialize(mark, random)
    @random = random
    @mark = mark
  end

  def ask_for_location(state)
    select_random state.available_locations
  end

  private
  attr_accessor :random

  def select_random(list)
    index = bounded_random list.size
    list[index]
  end

  def bounded_random(outer_bound)
    (random.rand * outer_bound).to_i
  end
end

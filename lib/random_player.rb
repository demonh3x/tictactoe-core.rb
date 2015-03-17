class RandomPlayer
  attr_reader :mark

  def initialize(mark, random=Random.new)
    @random = random
    @mark = mark
  end

  def ask_for_location(state)
    select_random available_locations state
  end

  private
  attr_accessor :random

  def available_locations(state)
    state.board.locations.select{|location| state.look_at(location).nil?}
  end

  def select_random(list)
    index = random_until list.size
    list[index]
  end

  def random_until(outer_bound)
    (random.rand * outer_bound).to_i
  end
end

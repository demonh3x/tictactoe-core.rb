require 'minimax'

class PerfectPlayer
  def initialize(me, opponent)
    @me = me
    @opponent = opponent
  end

  def ask_for_location(state)
    Minimax.new(state, me, opponent, me).best_options.first
  end
  
  def mark
    me
  end

  private
  attr_reader :me, :opponent
end

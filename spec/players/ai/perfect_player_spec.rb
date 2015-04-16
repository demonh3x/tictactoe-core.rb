require 'spec_helper'
require 'players/ai/perfect_player'
require 'core/state'
require 'boards/three_by_three_board'

RSpec.describe Players::AI::PerfectPlayer do
  def board(*marks)
    state = Core::State.new(Boards::ThreeByThreeBoard.new)
    marks.each_with_index do |mark, location|
      state = state.make_move(location, mark)
    end
    state
  end

  before(:each) do
    @player = described_class.new(:x, :o)
  end

  def play(state)
    @player.call(state)
  end

  it 'given only one possible play, should do it' do
    state = board(
      :x, :o, nil,
      :o, :x, :x,
      :x, :o, :o
    )
    expect(play(state)).to eq [2]
  end

  it 'given the possibility to lose, should prefer a draw' do
    player = described_class.new(:o, :x)
    state = board(
      :x, nil, :o,
      :o, :x,  :x,
      :x, :o,  nil 
    )
    expect(player.call(state)).to eq [8]
  end
  
  it 'given the possibility to win, should do it' do
    state = board(
      :x,  :o,  :x,
      :o,  :x,  :o,
      nil, nil, :o 
    )
    expect(play(state)).to eq [6]
  end

  it 'given the possibility to fork, should do it' do
    state = board(
      nil, nil, :x,
      nil, nil, :o,
      :o,  nil, :x
    )
    expect(play(state)).to eq [0]
  end

  it 'having a possibility of a fork against, should attack to avoid it' do
    state = board(
      :o, nil, nil,
      :x, nil, nil,
      :o, nil, nil 
    )
    expect(play(state)).to eq [4]
  end
end

require 'spec_helper'
require 'tictactoe/ai/perfect_player'
require 'tictactoe/state'
require 'tictactoe/boards/three_by_three_board'

RSpec.describe Tictactoe::Ai::PerfectPlayer do
  def board(*marks)
    state = Tictactoe::State.new(Tictactoe::Boards::ThreeByThreeBoard.new)
    marks.each_with_index do |mark, location|
      state = state.make_move(location, mark)
    end
    state
  end

  class ChoosesFirst
    def choose_one(list)
      list.first
    end
  end

  def play(player, state)
    opponent = player == :x ? :o : :x
    @player = described_class.new(player, opponent, ChoosesFirst.new)
    @player.update(state)
    @player.play_location
  end

  it 'given only one possible play, should do it' do
    state = board(
      :x, :o, nil,
      :o, :x, :x,
      :x, :o, :o
    )
    expect(play(:x, state)).to eq 2
  end

  it 'given the possibility to lose, should prefer a draw' do
    state = board(
      :x, nil, :o,
      :o, :x,  :x,
      :x, :o,  nil 
    )
    expect(play(:o, state)).to eq 8
  end
  
  it 'given the possibility to win, should do it' do
    state = board(
      :x,  :o,  :x,
      :o,  :x,  :o,
      nil, nil, :o 
    )
    expect(play(:x, state)).to eq 6
  end

  it 'given the possibility to fork, should do it' do
    state = board(
      nil, nil, :x,
      nil, nil, :o,
      :o,  nil, :x
    )
    expect(play(:x, state)).to eq 0
  end

  it 'having a possibility of a fork against, should attack to avoid it' do
    state = board(
      :o, nil, nil,
      :x, nil, nil,
      :o, nil, nil 
    )
    expect(play(:x, state)).to eq 4
  end
end

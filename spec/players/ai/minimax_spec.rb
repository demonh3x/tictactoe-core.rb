require 'spec_helper'
require 'core/state'
require 'boards/three_by_three_board'
require 'players/ai/minimax'
require 'timeout'

RSpec.describe Minimax do
  def board(*marks)
    state = State.new(ThreeByThreeBoard.new)
    marks.each_with_index do |mark, location|
      state = state.make_move(location, mark)
    end
    state
  end

  it 'given a draw' do
    draw_state = board(
      :X, :O, :X,
      :O, :X, :X,
      :O, :X, :O
    )
    minimax = described_class.new(:O, :X, :O)
    expect(minimax.strategies(draw_state)).to eq({:best => []})
  end

  it 'given a won state' do
    won_state = board(
      :X, :O, :X,
      :O, :X, :O,
      :O, :X, :X
    )
    minimax = described_class.new(:O, :X, :O)
    expect(minimax.strategies(won_state)).to eq({:best => []})
  end

  it 'given a lost state' do
    lost_state = board(
      :O, :X, :X,
      :X, :O, :X,
      :O, :X, :O
    )
    minimax = described_class.new(:O, :X, :O)
    expect(minimax.strategies(lost_state)).to eq({:best => []})
  end

  it 'given a winnable state by X' do
    winnable_state_by_x = board(
      :X, :O, :X,
      :O, :X, :O,
      :O, :X, nil
    )
    minimax = described_class.new(:X, :O, :X)
    expect(minimax.strategies(winnable_state_by_x)).to eq({:win => [8], :best => [8]})
  end

  it 'given a winnable state by O' do
    winnable_state_by_o = board(
      :O, :X,  :X,
      :X, :O,  :O,
      :X, nil, nil
    )
    minimax = described_class.new(:O, :X, :O)
    expect(minimax.strategies(winnable_state_by_o)).to eq({:win => [8], :draw => [7], :best => [8]})
  end

  it 'given a winnable state by X' do
    winnable_state_by_x = board(
      :O,  :X,  :X,
      :O,  :O,  :X,
      nil, nil, nil
    )
    minimax = described_class.new(:X, :O, :X)
    expect(minimax.strategies(winnable_state_by_x)).to eq({:win => [8], :lose => [6, 7], :best => [8]})
  end

  it 'given the possibility to end in a draw instead of losing' do
    state = board(
      :O, :X,  :O,
      :X, :O,  :X,
      :X, nil, nil
    )
    minimax = described_class.new(:X, :O, :X)
    expect(minimax.strategies(state)).to eq({:lose => [7], :draw => [8], :best => [8]})
  end

  it 'given the posibility to double fork' do
    state = board(
      :X,  :O,  :X,
      nil, nil, nil,
      nil, nil, :O
    )
    minimax = described_class.new(:X, :O, :X)
    expect(minimax.strategies(state)).to eq({:lose => [5], :draw => [3, 4, 7], :win => [6], :best => [6]})
  end

  it 'given an empty state anything is a draw', :slow => true do
    state = board(
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    )
    minimax = described_class.new(:X, :O, :X)
    expect(minimax.strategies(state)).to eq({:draw => [0, 1, 2, 3, 4, 5, 6, 7, 8], :best => [0, 1, 2, 3, 4, 5, 6, 7, 8]})
  end
end

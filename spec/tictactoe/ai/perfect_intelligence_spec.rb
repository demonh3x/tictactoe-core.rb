require 'spec_helper'
require 'tictactoe/ai/perfect_intelligence'
require 'tictactoe/state'
require 'tictactoe/players'
require 'tictactoe/boards/three_by_three_board'

RSpec.describe Tictactoe::Ai::PerfectIntelligence do
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

  def play(state)
    @player = described_class.new(Tictactoe::Players.new(:x, :o).first)
    @player.desired_moves(state)
  end

  it 'given only one possible play, should do it' do
    state = board(
      :x, :o, nil,
      :o, :x, :x,
      :x, :o, :o
    )
    expect(play(state)).to eq [2]
  end

  it 'given the possibility to lose, should block' do
    state = board(
      :x, nil, nil,
      :o, nil, :o,
      :x, nil, nil
    )
    expect(play(state)).to eq [4]
  end
  
  it 'given the possibility to lose, should block, not matter if there is a fork comming' do
    state = board(
      :x, nil, nil,
      :x, nil, nil,
      :o, nil, :o,
    )
    expect(play(state)).to eq [7]
  end

  it 'given the possibility to win, should prefer it' do
    state = board(
      :x,  :o,  :x,
      :o,  :x,  :o,
      nil, nil, :o 
    )
    expect(play(state)).to eq [6]
  end

  it 'given the possibility to win, should prefer it over blocking or forking' do
    state = board(
      :x,  nil, :o,
      nil, nil, :o,
      :x,  nil, nil
    )
    expect(play(state)).to eq [3]
  end

  it 'given the possibility to fork, should prefer it' do
    state = board(
      :x,  :o,  :x,
      nil, nil, :o,
      nil, nil, nil
    )
    expect(play(state)).to eq [4, 6]
  end

  it 'given the possibility to block, should prefer it over forking' do
    state = board(
      nil, nil, :x,
      nil, :o,  nil,
      :x,  :o,  nil
    )
    expect(play(state)).to eq [1]
  end

  it 'given the possibility to block a fork, should do it' do
    #:o started the game
    state = board(
      :o,  :x,  :o,
      nil, nil, nil,
      nil, nil, nil,
    )
    expect(play(state)).to eq [4]
  end

  it 'given two possible forks for the opponent, should attack avoiding the creation of the fork' do
    #:o started the game
    state = board(
      nil, nil, :o,
      nil, :x,  nil,
      :o,  nil, nil,
    )
    expect(play(state)).to eq [1, 3, 5, 7]
  end
end

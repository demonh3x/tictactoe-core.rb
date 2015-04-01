require 'perfect_player'
require 'core/state'
require 'three_by_three_board'

RSpec.describe "Perfect player" do
  def board(*marks)
    state = State.new(ThreeByThreeBoard.new)
    marks.each_with_index do |mark, location|
      state = state.put(location, mark)
    end
    state
  end

  before(:each) do
    @player = PerfectPlayer.new(:x, :o, spy(:rand => 0.0))
  end

  def play(state)
    @player.ask_for_location state
  end

  it 'should have the mark' do
    expect(@player.mark).to eq :x
  end

  it 'given only one possible play, should do it' do
    state = board(
      :x, :o, nil,
      :o, :x, :x,
      :x, :o, :o
    )
    expect(play(state)).to eq 2
  end

  it 'given the possibility to lose, should prefer a draw' do
    state = board(
      :x, nil, :o,
      :o, :x,  :x,
      :x, :o,  nil 
    )
    expect(play(state)).to eq 8
  end
  
  it 'given the possibility to win, should do it' do
    state = board(
      :x,  :o,  :x,
      :o,  :x,  nil,
      nil, nil, :o 
    )
    expect(play(state)).to eq 6
  end

  it 'given the possibility to fork, should do it' do
    state = board(
      nil, nil, :x,
      nil, nil, :o,
      :o,  nil, :x
    )
    expect(play(state)).to eq 0
  end

  it 'having a possibility of a fork against, should attack to avoid it' do
    state = board(
      :o, nil, nil,
      :x, nil, nil,
      :o, nil, nil 
    )
    expect(play(state)).to eq 4
  end
end

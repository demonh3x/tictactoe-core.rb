require 'minimax'

RSpec.describe 'Minimax player' do
  def board(*marks)
    state = State.new(ThreeByThreeBoard.new)
    marks.each_with_index do |mark, location|
      state = state.put(location, mark)
    end
    state
  end

  it 'given a draw the score should be 0' do
    draw_state = board(
      :X, :O, :X,
      :O, :X, :X,
      :O, :X, :O
    )
    minimax = Minimax.new(draw_state, :X, :O)
    expect(minimax.score).to eq 0
  end

  it 'given a won state, the score should be 1' do
    won_state = board(
      :X, :O, :X,
      :O, :X, :O,
      :O, :X, :X
    )
    minimax = Minimax.new(won_state, :X, :O)
    expect(minimax.score).to eq 1
  end

  it 'given a lost state, the score should be -1' do
    lost_state = board(
      :O, :X, :X,
      :X, :O, :X,
      :O, :X, :O
    )
    minimax = Minimax.new(lost_state, :X, :O)
    expect(minimax.score).to eq(-1)
  end

  it 'given a winnable state by X, the score should be 1' do
    winnable_state_by_x = board(
      :X, :O, :X,
      :O, :X, :O,
      :O, :X, nil
    )
    minimax = Minimax.new(winnable_state_by_x, :X, :X)
    expect(minimax.score).to eq(1)
  end

  it 'given a winnable state by O, the score should be 1' do
    winnable_state_by_o = board(
      :O, :X, :X,
      :X, :O, :O,
      :X, nil, nil
    )
    minimax = Minimax.new(winnable_state_by_o, :O, :O)
    expect(minimax.score).to eq(1)
  end

  it 'given a winnable state by X, the score should be 1' do
    winnable_state_by_o = board(
      :O, :X, :X,
      :O, :O, :X,
      nil, nil, nil
    )
    minimax = Minimax.new(winnable_state_by_o, :X, :X)
    expect(minimax.score).to eq(1)
  end

  it 'given the possibility to end in a draw instead of losing, the score should be 0' do
    state = board(
      :O, :X, :O,
      :X, :O, :X,
      :X, nil, nil
    )
    minimax = Minimax.new(state, :X, :X)
    expect(minimax.score).to eq(0)
  end

  it 'given the possibility to lose if the opponent is choosing, the score should be -1' do
    state = board(
      :O, :X, :O,
      nil, :O, :X,
      :X, nil, nil
    )
    minimax = Minimax.new(state, :X, :O)
    expect(minimax.score).to eq(-1)
  end
end

require 'tictactoe/game'

RSpec.describe Tictactoe::Game do
  class MovesSource
    attr_reader :moves

    def initialize()
      @moves = []
    end

    def add(move)
      moves << move
    end

    def get_move!
      moves.pop
    end
  end

  let(:moves_source) {MovesSource.new}

  def create(board_size, x_type, o_type)
    described_class.new(board_size, x_type, o_type, moves_source)
  end

  def human_tick_playing_to(ttt, loc)
    moves_source.add(loc)
    ttt.tick()
  end
  
  def computer_tick(ttt)
    ttt.tick()
  end

  def expect_amount_of_marks(ttt, mark, expected_count)
    actual_count = ttt.marks.select{|m| m == mark}.count
    expect(actual_count).to eq(expected_count)
  end

  it 'is not finished' do
    ttt = create(3, :human, :human)
    expect(ttt.is_finished?).to eq(false)
  end

  describe 'can be observed' do
    it 'initial game size 3' do
      ttt = create(3, :human, :human)
      expect(ttt.marks).to eq([
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end

    it 'initial game size 4' do
      ttt = create(4, :human, :human)
      expect(ttt.marks).to eq([
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil
      ])
    end

    it 'first play of x on size 3' do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      expect(ttt.marks).to eq([
        :x,  nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
    
    it 'first play of o on size 3' do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 1)
      expect(ttt.marks).to eq([
        :x,  :o,  nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
  end

  describe 'has the available locations' do
    it do
      ttt = create(3, :human, :human)
      expect(ttt.available).to eq([
        0, 1, 2,
        3, 4, 5,
        6, 7, 8
      ])
    end

    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      expect(ttt.available).to eq([
           1, 2,
        3, 4, 5,
        6, 7, 8
      ])
    end

    it do
      ttt = create(4, :human, :human)
      human_tick_playing_to(ttt, 15)
      expect(ttt.available).to eq([
        0, 1, 2, 3,
        4, 5, 6, 7,
        8, 9,10,11,
       12,13,14
      ])
    end
  end

  describe 'is not finished if no player has a line' do
    it do
      ttt = create(4, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 4)
      human_tick_playing_to(ttt, 1)
      human_tick_playing_to(ttt, 5)
      human_tick_playing_to(ttt, 2)
      human_tick_playing_to(ttt, 6)
      expect(ttt.is_finished?).to eq(false)
    end
    
    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 3)
      human_tick_playing_to(ttt, 1)
      human_tick_playing_to(ttt, 4)
      expect(ttt.is_finished?).to eq(false)
    end
  end

  describe 'is finished when a player has a line' do
    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 3)
      human_tick_playing_to(ttt, 1)
      human_tick_playing_to(ttt, 4)
      human_tick_playing_to(ttt, 2)
      expect(ttt.is_finished?).to eq(true)
      expect(ttt.winner).to eq(:x)
    end

    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 3)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 4)
      human_tick_playing_to(ttt, 1)
      human_tick_playing_to(ttt, 8)
      human_tick_playing_to(ttt, 2)
      expect(ttt.is_finished?).to eq(true)
      expect(ttt.winner).to eq(:o)
    end

    it do
      ttt = create(4, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 4)
      human_tick_playing_to(ttt, 1)
      human_tick_playing_to(ttt, 5)
      human_tick_playing_to(ttt, 2)
      human_tick_playing_to(ttt, 6)
      human_tick_playing_to(ttt, 3)
      expect(ttt.is_finished?).to eq(true)
      expect(ttt.winner).to eq(:x)
    end
  end

  describe 'is finished when the board is full' do
    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 1)
      human_tick_playing_to(ttt, 2)
      human_tick_playing_to(ttt, 5)
      human_tick_playing_to(ttt, 3)
      human_tick_playing_to(ttt, 6)
      human_tick_playing_to(ttt, 4)
      human_tick_playing_to(ttt, 8)
      human_tick_playing_to(ttt, 7)
      expect(ttt.marks).to eq([
        :x, :o, :x,
        :x, :x, :o,
        :o, :x, :o
      ])
      expect(ttt.is_finished?).to eq(true)
    end
  end

  describe 'cant play twice to the same location' do
    it 'second play' do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 0)
      expect(ttt.marks).to eq([
        :x,  nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
  end

  describe 'cant be played when finished' do
    it do
      ttt = create(3, :human, :human)

      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, 3)
      human_tick_playing_to(ttt, 1)
      human_tick_playing_to(ttt, 4)
      human_tick_playing_to(ttt, 2)

      human_tick_playing_to(ttt, 5)

      expect(ttt.marks).to eq([
        :x,  :x,  :x,
        :o,  :o,  nil,
        nil, nil, nil
      ])
    end
  end

  describe 'if the human has no move ignores the ticks' do
    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, nil)
      human_tick_playing_to(ttt, nil)
      human_tick_playing_to(ttt, nil)
      expect_amount_of_marks(ttt, :x, 0)
    end

    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, nil)
      human_tick_playing_to(ttt, nil)
      human_tick_playing_to(ttt, nil)
      human_tick_playing_to(ttt, 0)
      expect_amount_of_marks(ttt, :x, 1)
      expect_amount_of_marks(ttt, :o, 0)
    end

    it do
      ttt = create(3, :human, :human)
      human_tick_playing_to(ttt, 0)
      human_tick_playing_to(ttt, nil)
      human_tick_playing_to(ttt, nil)
      human_tick_playing_to(ttt, nil)
      expect_amount_of_marks(ttt, :x, 1)
      expect_amount_of_marks(ttt, :o, 0)
    end
  end

  describe 'the computer plays' do
    it 'the first turn' do
      ttt = create(3, :computer, :human)
      computer_tick(ttt)
      expect_amount_of_marks(ttt, :x, 1)
      expect_amount_of_marks(ttt, :o, 0)
    end

    it 'the second turn' do
      ttt = create(3, :human, :computer)
      human_tick_playing_to(ttt, 0)
      computer_tick(ttt)
      expect_amount_of_marks(ttt, :x, 1)
      expect_amount_of_marks(ttt, :o, 1)
    end

    it 'four consecutive turns' do
      ttt = create(3, :computer, :computer)
      computer_tick(ttt)
      computer_tick(ttt)
      computer_tick(ttt)
      computer_tick(ttt)
      expect_amount_of_marks(ttt, :x, 2)
      expect_amount_of_marks(ttt, :o, 2)
    end
  end
end

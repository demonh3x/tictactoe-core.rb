require 'tictactoe/game'

RSpec.describe Tictactoe::Game do
  class Human
    attr_reader :mark

    def initialize(mark, moves)
      @mark = mark 
      @moves = moves
    end

    def get_move(state)
      @moves.pop
    end
  end

  let(:moves){[]}

  def create(board_size, x_type, o_type)
    game = described_class.new(board_size, x_type, o_type)
    game.register_human_factory(lambda{|mark| Human.new(mark, moves)})
    game
  end

  def human_tick_playing_to(game, loc)
    moves << loc
    game.tick()
  end
  
  def computer_tick(game)
    game.tick()
  end

  def expect_amount_of_marks(game, mark, expected_count)
    actual_count = game.marks.select{|m| m == mark}.count
    expect(actual_count).to eq(expected_count)
  end

  it 'is not finished' do
    game = create(3, :human, :human)
    expect(game.is_finished?).to eq(false)
  end

  describe 'can be observed' do
    it 'initial game size 3' do
      game = create(3, :human, :human)
      expect(game.marks).to eq([
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end

    it 'initial game size 4' do
      game = create(4, :human, :human)
      expect(game.marks).to eq([
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil
      ])
    end

    it 'first play of x on size 3' do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      expect(game.marks).to eq([
        :x,  nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
    
    it 'first play of o on size 3' do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 1)
      expect(game.marks).to eq([
        :x,  :o,  nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
  end

  describe 'available' do
    it 'returns all the moves when no move has been made' do
      game = create(3, :human, :human)
      expect(game.available).to eq([
        0, 1, 2,
        3, 4, 5,
        6, 7, 8
      ])
    end

    it 'returns all the available moves for when there is one move made on 3 by 3' do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      expect(game.available).to eq([
           1, 2,
        3, 4, 5,
        6, 7, 8
      ])
    end

    it 'returns all the available moves for when there is one move made on 4 by 4' do
      game = create(4, :human, :human)
      human_tick_playing_to(game, 15)
      expect(game.available).to eq([
        0, 1, 2, 3,
        4, 5, 6, 7,
        8, 9,10,11,
       12,13,14
      ])
    end
  end

  describe 'is not finished if no player has a line' do
    it do
      game = create(4, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 4)
      human_tick_playing_to(game, 1)
      human_tick_playing_to(game, 5)
      human_tick_playing_to(game, 2)
      human_tick_playing_to(game, 6)
      expect(game.is_finished?).to eq(false)
    end
    
    it do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 3)
      human_tick_playing_to(game, 1)
      human_tick_playing_to(game, 4)
      expect(game.is_finished?).to eq(false)
    end
  end

  describe 'is finished when a player has a line' do
    it do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 3)
      human_tick_playing_to(game, 1)
      human_tick_playing_to(game, 4)
      human_tick_playing_to(game, 2)
      expect(game.is_finished?).to eq(true)
      expect(game.winner).to eq(:x)
    end

    it do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 3)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 4)
      human_tick_playing_to(game, 1)
      human_tick_playing_to(game, 8)
      human_tick_playing_to(game, 2)
      expect(game.is_finished?).to eq(true)
      expect(game.winner).to eq(:o)
    end

    it do
      game = create(4, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 4)
      human_tick_playing_to(game, 1)
      human_tick_playing_to(game, 5)
      human_tick_playing_to(game, 2)
      human_tick_playing_to(game, 6)
      human_tick_playing_to(game, 3)
      expect(game.is_finished?).to eq(true)
      expect(game.winner).to eq(:x)
    end
  end

  describe 'is finished when the board is full' do
    it do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 1)
      human_tick_playing_to(game, 2)
      human_tick_playing_to(game, 5)
      human_tick_playing_to(game, 3)
      human_tick_playing_to(game, 6)
      human_tick_playing_to(game, 4)
      human_tick_playing_to(game, 8)
      human_tick_playing_to(game, 7)
      expect(game.marks).to eq([
        :x, :o, :x,
        :x, :x, :o,
        :o, :x, :o
      ])
      expect(game.is_finished?).to eq(true)
    end
  end

  describe 'cannot play twice to the same move' do
    it 'second play' do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 0)
      expect(game.marks).to eq([
        :x,  nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
  end

  describe 'cannot be played when finished' do
    it do
      game = create(3, :human, :human)

      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, 3)
      human_tick_playing_to(game, 1)
      human_tick_playing_to(game, 4)
      human_tick_playing_to(game, 2)

      human_tick_playing_to(game, 5)

      expect(game.marks).to eq([
        :x,  :x,  :x,
        :o,  :o,  nil,
        nil, nil, nil
      ])
    end
  end

  describe 'if the human has no move ignores the ticks' do
    it do
      game = create(3, :human, :human)
      human_tick_playing_to(game, nil)
      human_tick_playing_to(game, nil)
      human_tick_playing_to(game, nil)
      expect_amount_of_marks(game, :x, 0)
    end

    it do
      game = create(3, :human, :human)
      human_tick_playing_to(game, nil)
      human_tick_playing_to(game, nil)
      human_tick_playing_to(game, nil)
      human_tick_playing_to(game, 0)
      expect_amount_of_marks(game, :x, 1)
      expect_amount_of_marks(game, :o, 0)
    end

    it do
      game = create(3, :human, :human)
      human_tick_playing_to(game, 0)
      human_tick_playing_to(game, nil)
      human_tick_playing_to(game, nil)
      human_tick_playing_to(game, nil)
      expect_amount_of_marks(game, :x, 1)
      expect_amount_of_marks(game, :o, 0)
    end
  end

  describe 'the computer plays' do
    it 'the first turn' do
      game = create(3, :computer, :human)
      computer_tick(game)
      expect_amount_of_marks(game, :x, 1)
      expect_amount_of_marks(game, :o, 0)
    end

    it 'the second turn' do
      game = create(3, :human, :computer)
      human_tick_playing_to(game, 0)
      computer_tick(game)
      expect_amount_of_marks(game, :x, 1)
      expect_amount_of_marks(game, :o, 1)
    end

    it 'four consecutive turns' do
      game = create(3, :computer, :computer)
      computer_tick(game)
      computer_tick(game)
      computer_tick(game)
      computer_tick(game)
      expect_amount_of_marks(game, :x, 2)
      expect_amount_of_marks(game, :o, 2)
    end
  end
end

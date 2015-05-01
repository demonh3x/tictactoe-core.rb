require 'core/tictactoe'

RSpec.describe Core::TicTacToe do
  let (:ttt) {
    described_class.new
  }
  
  def human_tick_playing_to(loc)
    ttt.tick(loc)
  end
  
  def computer_tick
    ttt.tick(:ignored_player_because_computer_plays)
  end

  def expect_amount_of_marks(mark, expected_count)
    actual_count = ttt.marks.select{|m| m == mark}.count
    expect(actual_count).to eq(expected_count)
  end

  it 'is not finished' do
    ttt.set_board_size(3)
    expect(ttt.is_finished?).to eq(false)
  end

  describe 'can be observed' do
    it 'initial game size 3' do
      ttt.set_board_size(3)
      expect(ttt.marks).to eq([
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end

    it 'initial game size 4' do
      ttt.set_board_size(4)
      expect(ttt.marks).to eq([
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil
      ])
    end

    it 'first play of x on size 3' do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      human_tick_playing_to(0)
      expect(ttt.marks).to eq([
        :x,  nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
    
    it 'first play of o on size 3' do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      human_tick_playing_to(1)
      expect(ttt.marks).to eq([
        :x,  :o, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
  end
  
  describe 'has the available locations' do
    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      expect(ttt.available).to eq([
        0, 1, 2,
        3, 4, 5,
        6, 7, 8
      ])
    end

    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      expect(ttt.available).to eq([
           1, 2,
        3, 4, 5,
        6, 7, 8
      ])
    end

    it do
      ttt.set_board_size(4)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(15)
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
      ttt.set_board_size(4)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      human_tick_playing_to(4)
      human_tick_playing_to(1)
      human_tick_playing_to(5)
      human_tick_playing_to(2)
      human_tick_playing_to(6)
      expect(ttt.is_finished?).to eq(false)
    end
    
    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      human_tick_playing_to(3)
      human_tick_playing_to(1)
      human_tick_playing_to(4)
      expect(ttt.is_finished?).to eq(false)
    end
  end

  describe 'is finished when a player has a line' do
    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      human_tick_playing_to(3)
      human_tick_playing_to(1)
      human_tick_playing_to(4)
      human_tick_playing_to(2)
      expect(ttt.is_finished?).to eq(true)
      expect(ttt.winner).to eq(:x)
    end

    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(3)
      human_tick_playing_to(0)
      human_tick_playing_to(4)
      human_tick_playing_to(1)
      human_tick_playing_to(8)
      human_tick_playing_to(2)
      expect(ttt.is_finished?).to eq(true)
      expect(ttt.winner).to eq(:o)
    end

    it do
      ttt.set_board_size(4)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      human_tick_playing_to(4)
      human_tick_playing_to(1)
      human_tick_playing_to(5)
      human_tick_playing_to(2)
      human_tick_playing_to(6)
      human_tick_playing_to(3)
      expect(ttt.is_finished?).to eq(true)
      expect(ttt.winner).to eq(:x)
    end
  end


  describe 'is finished when the board is full' do
    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      human_tick_playing_to(1)
      human_tick_playing_to(2)
      human_tick_playing_to(5)
      human_tick_playing_to(3)
      human_tick_playing_to(6)
      human_tick_playing_to(4)
      human_tick_playing_to(8)
      human_tick_playing_to(7)
      expect(ttt.marks).to eq([
        :x, :o, :x,
        :x, :x, :o,
        :o, :x, :o
      ])
      expect(ttt.is_finished?).to eq(true)
    end
  end

  describe 'if the human has no move ignores the ticks' do
    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(nil)
      human_tick_playing_to(nil)
      human_tick_playing_to(nil)
      expect_amount_of_marks(:x, 0)
    end

    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(nil)
      human_tick_playing_to(nil)
      human_tick_playing_to(nil)
      human_tick_playing_to(0)
      expect_amount_of_marks(:x, 1)
      expect_amount_of_marks(:o, 0)
    end

    it do
      ttt.set_board_size(3)
      ttt.set_player_x(:human)
      ttt.set_player_o(:human)
      human_tick_playing_to(0)
      human_tick_playing_to(nil)
      human_tick_playing_to(nil)
      human_tick_playing_to(nil)
      expect_amount_of_marks(:x, 1)
      expect_amount_of_marks(:o, 0)
    end
  end
end

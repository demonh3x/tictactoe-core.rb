require 'game'
require 'state'
require 'three_by_three_board'

RSpec.describe "Game" do
  before(:each) do
    @board = ThreeByThreeBoard.new
    @game = Game.new(State.new(@board))
  end

  def expect_state(marks)
      marks.each_with_index do |mark, location|
        expect(@game.state.look_at location).to eq(mark)
      end
  end

  describe "with no moves" do
    it "should have an empty state" do
      expect_state([nil, nil, nil, nil, nil, nil, nil, nil, nil])
    end

    it "the game should not be finished" do
      expect(@game.is_finished?).to eq(false)
    end

    it "should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end

  describe "with the first move" do
    before(:each) do
      @loc = 0
      @game.make_move(:X, @loc)
    end

    it "the state should contain that move" do
      expect(@game.state.look_at(@loc)).to eq(:X)
    end
  end

  ThreeByThreeBoard.new.lines.each do |line|
    describe "with a line for player a" do
      before(:each) do
        line.each do |l|
          @game.make_move(:X, l)
        end
      end

      it "the game should be finished" do
        expect(@game.is_finished?).to eq(true)
      end

      it "should have won" do
        expect(@game.winner).to eq(:X)
      end
    end
  end

  def set_state(*marks)
    marks.each_with_index do |mark, location|
      @game.make_move(mark, location)
    end
  end

  describe "with three moves not in line for player a" do
    before(:each) do
      set_state(
        :X,  :X,  nil,
        :X,  nil, nil,
        nil, nil, nil
      )
    end
    
    it "the game should not be finished" do
      expect(@game.is_finished?).to eq(false)
    end

    it "should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end

  describe "with a full board but no winner" do
    before(:each) do
      set_state(
        :O, :X, :X,
        :X, :X, :O,
        :O, :O, :X
      )
    end

    it "the game should be finished" do
      expect(@game.is_finished?).to eq(true)
    end

    it "should have no winner" do
      expect(@game.winner).to eq(nil)
    end
  end
end

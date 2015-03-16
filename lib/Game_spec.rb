require 'game'
require 'state'
require 'three_by_three_board'

RSpec.describe "Game" do
  before(:each) do
    @board = ThreeByThreeBoard.new
    @game = Game.new(State.new(@board, {}))
  end

  def expect_state(loc_marks_map)
      loc_marks_map.each do |loc, mark|
        expect(@game.state.look_at loc).to eq(mark)
      end
  end

  describe "with no moves" do
    it "should have an empty state" do
      expect_state({
        Location.new(0, 0) => nil,  
        Location.new(0, 1) => nil,  
        Location.new(0, 2) => nil,  
        Location.new(1, 0) => nil,  
        Location.new(1, 1) => nil,  
        Location.new(1, 2) => nil,  
        Location.new(2, 0) => nil,  
        Location.new(2, 1) => nil,  
        Location.new(2, 2) => nil,  
      })
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
      @loc = Location.new(0, 0)
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

  def set_state(
    x0y0, x1y0, x2y0,
    x0y1, x1y1, x2y1,
    x0y2, x1y2, x2y2)
    {
      Location.new(0, 0) => x0y0,
      Location.new(1, 0) => x1y0,
      Location.new(2, 0) => x2y0,
      Location.new(0, 1) => x0y1,
      Location.new(1, 1) => x1y1,
      Location.new(2, 1) => x2y1,
      Location.new(0, 2) => x0y2,
      Location.new(1, 2) => x1y2,
      Location.new(2, 2) => x2y2,
    }.each do |l, p|
      @game.make_move(p, l)
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

require 'spec_helper'
require 'core/state'

RSpec.describe "Game state" do
  def look_at(state, location)
    state.layout
      .select{|loc, mark| loc == location}
      .map{|loc, mark| mark}
      .first
  end

  def expect_state(marks)
    marks.each_with_index do |mark, location|
      expect(look_at(@state, location)).to eq(mark)
    end
  end

  describe "given a 3x3 board" do
    before(:each) do
      @board = ThreeByThreeBoard.new
      @state = State.new(@board)
    end

    it "can make a move" do
      next_state = @state.make_move(3, :mark)
      expect(look_at(next_state, 3)).to eq(:mark)
      expect(next_state.available_moves).not_to include(3)
    end

    it "is immutable" do
      @state.make_move(2, :mark)
      expect(look_at(@state, 2)).to eq(nil)
      expect(@state.available_moves).to include(2)
    end

    it 'can access to the board layout' do
      expect(@state.layout).to eq([
        [0, nil], [1, nil], [2, nil],
        [3, nil], [4, nil], [5, nil],
        [6, nil], [7, nil], [8, nil],
      ])
    end

    describe "with no moves" do
      it "should have an empty state" do
        expect_state([nil, nil, nil, nil, nil, nil, nil, nil, nil])
      end

      it "should not be finished" do
        expect(@state.is_finished?).to eq(false)
      end

      it "should have no winner" do
        expect(@state.winner).to eq(nil)
      end
    end

    describe "with the first move" do
      before(:each) do
        @loc = 0
        @state = @state.make_move(@loc, :X)
      end

      it "should contain that move" do
        expect(look_at(@state, @loc)).to eq(:X)
      end
    end

    ThreeByThreeBoard.new.lines.each do |line|
      describe "with a line for player a" do
        before(:each) do
          line.each do |l|
            @state = @state.make_move(l, :X)
          end
        end

        it "should be finished" do
          expect(@state.is_finished?).to eq(true)
        end

        it "should have won" do
          expect(@state.winner).to eq(:X)
        end
      end
    end

    def set_state(*marks)
      marks.each_with_index do |mark, location|
        @state = @state.make_move(location, mark)
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

      it "should not be finished" do
        expect(@state.is_finished?).to eq(false)
      end

      it "should have no winner" do
        expect(@state.winner).to eq(nil)
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

      it "should be finished" do
        expect(@state.is_finished?).to eq(true)
      end

      it "should have no winner" do
        expect(@state.winner).to eq(nil)
      end
    end
  end
end

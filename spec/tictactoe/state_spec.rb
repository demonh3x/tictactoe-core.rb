require 'spec_helper'
require 'tictactoe/state'
require 'tictactoe/boards/three_by_three_board'

RSpec.describe Tictactoe::State do
  def look_at(state, location)
    state.marks[location]
  end

  def expect_state(marks)
    expect(@state.marks).to eq(marks)
  end

  def expect_finished(expected)
    finished = @state.when_finished{true} || false
    expect(finished).to eq(expected)
  end

  def expect_winner(expected)
    actual_winner = @state.when_finished{|winner| winner}
    expect(actual_winner).to eq(expected)
  end

  describe "given a 3x3 board" do
    before(:each) do
      @board = Tictactoe::Boards::ThreeByThreeBoard.new
      @state = described_class.new(@board)
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

    it 'can access to the board marks' do
      expect(@state.marks).to eq([
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil,
      ])
    end

    describe "with no moves" do
      it "should have an empty state" do
        expect_state([nil, nil, nil, nil, nil, nil, nil, nil, nil])
      end

      it "should not be finished" do
        expect_finished(false)
      end

      it "should have no winner" do
        expect_winner(nil)
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

    Tictactoe::Boards::ThreeByThreeBoard.new.lines.each do |line|
      describe "with a line for player a" do
        before(:each) do
          line.each do |l|
            @state = @state.make_move(l, :X)
          end
        end

        it "should be finished" do
          expect_finished(true)
        end

        it "should have won" do
          expect_winner(:X)
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
        expect_finished(false)
      end

      it "should have no winner" do
        expect_winner(nil)
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
        expect_finished(true)
      end

      it "should have no winner" do
        expect_winner(nil)
      end
    end
  end
end

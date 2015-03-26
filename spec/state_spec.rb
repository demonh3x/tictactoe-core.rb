require 'state'

RSpec.describe "Game state" do
  it "can look at a location" do
    initial_state = State.new(:board)
    next_state = initial_state.put(3, :mark)
    expect(next_state.look_at(3)).to eq(:mark)
  end

  it "is immutable" do
    initial_state = State.new(:board)
    initial_state.put(2, :mark)
    expect(initial_state.look_at(2)).to eq(nil)
  end

  describe "given a 3x3 board" do
    before(:each) do
      @board = ThreeByThreeBoard.new
      @state = State.new(@board)
    end

    def expect_state(marks)
        marks.each_with_index do |mark, location|
          expect(@state.look_at location).to eq(mark)
        end
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
        @state = @state.put(@loc, :X)
      end

      it "should contain that move" do
        expect(@state.look_at(@loc)).to eq(:X)
      end
    end

    ThreeByThreeBoard.new.lines.each do |line|
      describe "with a line for player a" do
        before(:each) do
          line.each do |l|
            @state = @state.put(l, :X)
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
        @state = @state.put(location, mark)
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

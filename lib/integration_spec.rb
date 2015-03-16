RSpec.describe "Integration" do
  describe "full game" do
    before(:each) do
      @x_in = StringIO.new("0,0\n0,1\n0,2\n")
      @o_in = StringIO.new("1,0\n1,1\n")
      @out = StringIO.new
      @coordinator = Coordinator.new(
        Game.new(State.new(ThreeByThreeBoard.new, {})),
        [
          Cli.new(@out, {:x => 'X', :o => 'O'})
        ],
        [
          CliPlayer.new(@x_in, @out, :x),
          CliPlayer.new(@o_in, @out, :o),
        ]
      )
    end

    describe "after running it" do
      before(:each) do
        while (!@coordinator.finished?)
          @coordinator.step
        end
      end

      it "should have announced the winner" do
        expect(@out.string).to include("X has won!")
      end
    end
  end
end

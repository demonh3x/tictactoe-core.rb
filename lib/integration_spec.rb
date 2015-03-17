RSpec.describe "Integration" do
  describe "full game" do
    before(:each) do
      @x_in = StringIO.new("0,0\n0,1\n0,2\n")
      @o_in = StringIO.new("1,0\n1,1\n")
      @out = StringIO.new
      @coordinator = Coordinator.new(
        Game.new(State.new(ThreeByThreeBoard.new, {})),
        [
          Cli.new({:x => 'X', :o => 'O'}, @out)
        ],
        [
          CliPlayer.new(:x, @x_in, @out),
          CliPlayer.new(:o, @o_in, @out),
        ]
      )
    end

    describe "after running it" do
      before(:each) do
        @coordinator.step until @coordinator.finished?
      end

      it "should have announced the winner" do
        expect(@out.string).to include("X has won!")
      end
    end
  end
end

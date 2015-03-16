require 'cli'
require 'location'
require 'three_by_three_board'

RSpec.describe "CLI Observer" do
  def state(
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
    }
  end

  before(:each) do
    @in = StringIO.new
    @out = StringIO.new
    @icons = {:X => 'X', :O => 'O'}
    @cli = Cli.new(@in, @out, @icons, :X)
  end

  describe "when updating" do
    describe "given an empty state" do
      it "prints it without pieces" do
        @cli.update(state(
          nil, nil, nil,
          nil, nil, nil,
          nil, nil, nil,
        ))
        expect(@out.string).to eq(
          "  x 0   1   2\n" +
          "y +---+---+---+\n" +
          "0 |   |   |   |\n" +
          "  +---+---+---+\n" +
          "1 |   |   |   |\n" +
          "  +---+---+---+\n" +
          "2 |   |   |   |\n" +
          "  +---+---+---+\n"
        )
      end
    end

    describe "given a state with some moves" do
      it "prints it with the pieces at the correct position" do
        @cli.update(state(
          :X,  nil, :O,
          nil, :O,  :X,
          nil, nil, nil,
        ))
        expect(@out.string).to eq(
          "  x 0   1   2\n" +
          "y +---+---+---+\n" +
          "0 | X |   | O |\n" +
          "  +---+---+---+\n" +
          "1 |   | O | X |\n" +
          "  +---+---+---+\n" +
          "2 |   |   |   |\n" +
          "  +---+---+---+\n"
        )
      end
    end
  end

  describe "when announcing the winner" do
    it "if is self, sould print that he/she is the winner" do
      @cli.announce_result(:X)
      expect(@out.string).to include("You win!")
    end

    it "if is someone else, should print that he/she lost" do
      @cli.announce_result(:O)
      expect(@out.string).to include("You lose.")
    end

    it "if no one won, should print that is a draw" do
      @cli.announce_result(nil)
      expect(@out.string).to include("It is a draw.")
    end
  end
end

RSpec.describe "CLI Player" do
  before(:each) do
    @in = StringIO.new
    @out = StringIO.new
    @board = ThreeByThreeBoard.new
    @cli = CliPlayer.new(@in, @out, @board)
  end

  def human_will_send(str)
    @in.string += "#{str}\n"
  end

  describe "when asking for a location" do
    it "prints the message doing it" do
      human_will_send("1,2")
      @cli.ask_for_location
      expect(@out.string).to include("Your turn! Where do you want to play? (format: x,y)\n")
    end

    describe "given no input" do
      it "raises an error" do
        expect{@cli.ask_for_location}.to raise_error("No data readed from the CLI input!")
      end
    end

    describe "given an input with no whitespaces" do
      it "reads the location" do
        human_will_send("1,2")
        expect(@cli.ask_for_location).to eq(Location.new(1, 2))
      end
    end

    describe "given an input with some whitespaces" do
      it "reads the location" do
        human_will_send("  \t 2 ,\t 0 ")
        expect(@cli.ask_for_location).to eq(Location.new(2, 0))
      end
    end

    def expect_invalid_input(invalid_input)
      human_will_send(invalid_input)
      human_will_send("1, 1")
      expect(@cli.ask_for_location).to eq(Location.new(1, 1))
      expect(@out.string).to include("Don't understand \"#{invalid_input}\". Please, make sure you use the format \"x,y\"\n")
    end

    describe "given an invalid input" do
      it "should try to read again" do
        expect_invalid_input("::invalid_input::")
      end
    end

    describe "given less coordinates than required" do
      it "should try to read again" do
        expect_invalid_input("1")
      end
    end

    describe "given more coordinates than required" do
      it "should try to read again" do
        expect_invalid_input("0, 1, 2")
      end
    end

    describe "given a location outside the board" do
      it "should try again" do
        human_will_send("3, 3")
        human_will_send("1, 1")
        expect(@cli.ask_for_location).to eq(Location.new(1, 1))
        expect(@out.string).to include("That location is outside the board. Please, try one inside it.\n")
      end
    end
  end

end

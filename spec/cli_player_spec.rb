require 'cli_player'
require 'three_by_three_board'

RSpec.describe "CLI Player" do
  before(:each) do
    @in = StringIO.new
    @out = StringIO.new
    @board = ThreeByThreeBoard.new
    @state = State.new(@board)
    @player = CliPlayer.new(:mark, @in, @out)
  end

  def human_will_send(str)
    @in.string += "#{str}\n"
  end

  def ask_for_location
    @player.ask_for_location(@state)
  end

  it "should have a mark" do
    expect(@player.mark).to eq(:mark)
  end

  describe "when asking for a location" do
    it "prints the message doing it" do
      human_will_send("1,2")
      ask_for_location
      expect(@out.string).to include("Your turn! Where do you want to play? (format: x,y)\n")
    end

    describe "given no input" do
      it "raises an error" do
        expect{ask_for_location}.to raise_error("No data readed from the CLI input!")
      end
    end

    describe "given an input with no whitespaces" do
      it "reads the location" do
        human_will_send("1,2")
        expect(ask_for_location).to eq(7)
      end
    end

    describe "given an input with some whitespaces" do
      it "reads the location" do
        human_will_send("  \t 2 ,\t 0 ")
        expect(ask_for_location).to eq(2)
      end
    end

    def expect_invalid_input(invalid_input)
      human_will_send(invalid_input)
      human_will_send("1, 1")
      expect(ask_for_location).to eq(4)
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
        expect(ask_for_location).to eq(4)
        expect(@out.string).to include("That location is not available. Please, try another one.\n")
      end
    end

    describe "given an already occupied location" do
      before(:each) do
        @state = @state.put(0, @player.mark)
      end

      it "should try again" do
        human_will_send("0, 0")
        human_will_send("1, 1")
        expect(ask_for_location).to eq(4)
        expect(@out.string).to include("That location is not available. Please, try another one.\n")
      end
    end
  end
end

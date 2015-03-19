RSpec.describe "Players option" do
  def cli_output(commands)
    input = commands.push("").join("\n")
    out = StringIO.new
    option = PlayersOption.new(StringIO.new(input), out, Random.new)
    option.ask
    out.string
  end

  it "should print the question" do
    expect(cli_output %w(hvh)).to include("Who will play?")
  end

  it "should print the options" do
    expect(cli_output %w(hvh)).to include(
      "hvh = Human VS Human\n" +
      "hvc = Human VS Computer\n" +
      "cvh = Computer VS Human\n" +
      "cvc = Computer VS Computer\n")
  end

  it "given an invalid option should say is invalid" do
    expect(cli_output %w(invalid hvh)).to include('"invalid" is not a valid option!')
  end

  it "given an invalid option should repeat the valid ones" do
    expect(cli_output %w(invalid hvh)).to include('try one of ["hvh", "hvc", "cvh", "cvc"]')
  end

  def ask_for_players(commands)
    input = commands.push("").join("\n")
    out = StringIO.new
    option = PlayersOption.new(StringIO.new(input), out, Random.new)
    option.ask
  end

  def expect_human_with_mark(player, mark)
    expect(player).to be_an_instance_of CliPlayer
    expect(player.mark).to eq(mark)
  end

  def expect_computer_with_mark(player, mark)
    expect(player).to be_an_instance_of RandomPlayer
    expect(player.mark).to eq(mark)
  end

  describe "answering human vs human" do
    before(:each) do
      @players = ask_for_players %w(hvh)
    end

    it "should return the first player human with mark X" do
      expect_human_with_mark(@players[0], :x)
    end

    it "should return the second player human with mark O" do
      expect_human_with_mark(@players[1], :o)
    end
  end

  describe "answering human vs computer" do
    before(:each) do
      @players = ask_for_players %w(hvc)
    end

    it "should return the first player human with mark X" do
      expect_human_with_mark(@players[0], :x)
    end

    it "should return the second player computer with mark O" do
      expect_computer_with_mark(@players[1], :o)
    end
  end

  describe "answering computer vs human" do
    before(:each) do
      @players = ask_for_players %w(cvh)
    end

    it "should return the first player computer with mark X" do
      expect_computer_with_mark(@players[0], :x)
    end

    it "should return the second player human with mark O" do
      expect_human_with_mark(@players[1], :o)
    end
  end

  describe "answering computer vs computer" do
    before(:each) do
      @players = ask_for_players %w(cvc)
    end

    it "should return the first player computer with mark X" do
      expect_computer_with_mark(@players[0], :x)
    end

    it "should return the second player computer with mark O" do
      expect_computer_with_mark(@players[1], :o)
    end
  end
end

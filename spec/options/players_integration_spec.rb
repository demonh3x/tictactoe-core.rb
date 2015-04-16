require 'spec_helper'
require 'players/cli_player'
require 'options/players_selection'
require 'players/players_factory'
require 'options/option'
require 'options/cli_asker'

RSpec.describe "Players integration" do
  def create(i, o)
    cli = Options::CliAsker.new(i, o)
    selection = Options::PlayersSelection.new(cli)
    factory = PlayersFactory.new(i, o, spy(:rand => 0.0))

    Options::Option.new(selection, factory)
  end

  def cli_output(commands)
    i = StringIO.new(commands.push("").join("\n"))
    o = StringIO.new
    option = create(i, o)
    option.get
    o.string
  end

  it "should print the question" do
    expect(cli_output %w(1)).to include("Who will play?")
  end

  it "should print the options" do
    expect(cli_output %w(1)).to include(
      "1 = Human VS Human\n" +
      "2 = Human VS Computer\n" +
      "3 = Computer VS Human\n" +
      "4 = Computer VS Computer\n")
  end

  it "given an invalid option should say is invalid" do
    expect(cli_output %w(invalid 1)).to include('"invalid" is not a valid option!')
  end

  it "given an invalid option should repeat the valid ones" do
    expect(cli_output %w(invalid 1)).to include('try one of ["1", "2", "3", "4"]')
  end

  def ask_for_players(commands)
    i = StringIO.new(commands.push("").join("\n"))
    o = StringIO.new
    option = create(i, o)
    option.get
  end

  def expect_human_with_mark(player, mark)
    expect(player).to be_an_instance_of Players::CliPlayer
    expect(player.mark).to eq(mark)
  end

  def expect_computer_with_mark(player, mark)
    expect(player).to be_an_instance_of Players::AI::RandomStrategyPlayer
    expect(player.mark).to eq(mark)
  end

  describe "answering human vs human" do
    before(:each) do
      @players = ask_for_players %w(1)
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
      @players = ask_for_players %w(2)
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
      @players = ask_for_players %w(3)
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
      @players = ask_for_players %w(4)
    end

    it "should return the first player computer with mark X" do
      expect_computer_with_mark(@players[0], :x)
    end

    it "should return the second player computer with mark O" do
      expect_computer_with_mark(@players[1], :o)
    end
  end
end

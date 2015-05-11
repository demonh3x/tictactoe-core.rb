require 'spec_helper'
require 'tictactoe/cli/runner'

RSpec.describe Tictactoe::Cli::Runner, :integration => true do
  def format_for_stdin(commands)
    commands.push("").join("\n")
  end

  def run_game(commands)
    input = StringIO.new format_for_stdin commands
    output = StringIO.new
    random = spy(:rand => 0.0)
    described_class.new(input, output, random).run
    output.string
  end

  describe "full game with 3x3 board between two humans" do
    before(:each) do
      @output = run_game %w(3 1 0 1 3 4 6 n)
    end

    it "should have printed the initial state" do
      expect(@output).to include(
        "+---+---+---+\n"\
        "| 0 | 1 | 2 |\n"\
        "+---+---+---+\n"\
        "| 3 | 4 | 5 |\n"\
        "+---+---+---+\n"\
        "| 6 | 7 | 8 |\n"\
        "+---+---+---+\n"\
      )
    end

    it "should have announced the winner" do
      expect(@output).to include("Player X has won!")
    end

    it "should have asked to play again" do
      expect(@output).to include("play again?")
    end

    it "should have asked for the size of the board" do
      expect(@output).to include("size of the board?")
    end

    it "should have asked for the players" do
      expect(@output).to include("Who will play?")
    end
  end
  
  describe "full game with 3x3 board between two humans ending in a draw" do
    it 'prints the message of a draw' do
      output = run_game %w(3 1 4 2 5 3 7 1 0 8 6 n)
      expect(output).to include("It is a draw.")
    end
  end

  describe "two full games with 3x3 board between two humans" do
    it "should have announced the winner of the second game" do
      commands = %w(3 1 0 1 3 4 6 y 3 1 0 1 3 4 2 7 n)
      expect(run_game commands).to include("Player O has won!")
    end
  end

  describe "full game with 3x3 board between computer and human", :slow => true do
    it "should have announced the winner" do
      expect(run_game %w(3 3 6 7 n)).to include("Player X has won!")
    end
  end

  describe "full game with 4x4 board between two humans" do
    before(:each) do
      @output = run_game %w(4 1 0 4 1 5 2 6 3 n)
    end

    it "should have printed the initial state" do
      expect(@output).to include(
        "+---+---+---+---+\n"\
        "| 0 | 1 | 2 | 3 |\n"\
        "+---+---+---+---+\n"\
        "| 4 | 5 | 6 | 7 |\n"\
        "+---+---+---+---+\n"\
        "| 8 | 9 | 10| 11|\n"\
        "+---+---+---+---+\n"\
        "| 12| 13| 14| 15|\n"\
        "+---+---+---+---+\n"\
      )
    end
  end
end

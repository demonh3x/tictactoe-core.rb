require 'main'

RSpec.describe "Integration" do
  def format_for_stdin(commands)
    commands.push("").join("\n")
  end

  class NotRandom
    def rand
      0.0
    end
  end

  def run_game(commands)
    input = StringIO.new format_for_stdin commands
    output = StringIO.new
    Main.new(input, output, NotRandom.new).run
    output.string
  end

  describe "full game with 3x3 board between two humans" do
    before(:each) do
      @output = run_game %w(3 hvh 0,0 1,0 0,1 1,1 0,2 n)
    end

    it "should have announced the winner" do
      expect(@output).to include("x has won!")
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
  
  describe "two full games with 3x3 board between two humans" do
    it "should have announced the winner of the second game" do
      commands = %w(3 hvh 0,0 1,0 0,1 1,1 0,2 y 3 hvh 0,0 1,0 0,1 1,1 2,0 1,2 n)
      expect(run_game commands).to include("o has won!")
    end
  end

  describe "full game with 3x3 board between computer and human" do
    it "should have announced the winner" do
      expect(run_game %w(3 cvh 0,2 1,2 n)).to include("x has won!")
    end
  end
end

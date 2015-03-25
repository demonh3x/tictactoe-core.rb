require 'play_again_option'

RSpec.describe "Play again option" do
  def cli_output(commands)
    input = commands.push("").join("\n")
    out = StringIO.new
    option = PlayAgainOption.new(StringIO.new(input), out)
    option.ask
    out.string
  end

  it "should print the question" do
    expect(cli_output %w(y)).to include("Do you want to play again?")
  end

  it "should print the options" do
    expect(cli_output %w(y)).to include("y = Yes\nn = No")
  end

  it "given an invalid option should say is invalid" do
    expect(cli_output %w(z y)).to include('"z" is not a valid option!')
  end

  it "given an invalid option should repeat the valid ones" do
    expect(cli_output %w(z y)).to include('try one of ["y", "n"]')
  end

  def play_again?(commands)
    input = commands.push("").join("\n")
    out = StringIO.new
    option = PlayAgainOption.new(StringIO.new(input), out)
    option.ask
  end

  it "should return true if answering yes" do
    expect(play_again? %w(y)).to eq(true)
  end

  it "should return false if answering no" do
    expect(play_again? %w(n)).to eq(false)
  end
end

require 'spec_helper'
require 'options/cli_asker'

require 'options/board_type_selection'
require 'boards/board_type_factory'
require 'options/option'

RSpec.describe "Board type integration" do
  def create(input, out)
    cli_asker = Options::CliAsker.new(input, out)
    selection = Options::BoardTypeSelection.new(cli_asker)
    factory = Boards::BoardTypeFactory.new
    Option.new(selection, factory)
  end

  def cli_output(commands)
    input = StringIO.new(commands.push("").join("\n"))
    out = StringIO.new
    option = create(input, out)
    option.get
    out.string
  end

  it "should print the question" do
    expect(cli_output %w(3)).to include("What will be the size of the board?")
  end

  it "should print the options" do
    expect(cli_output %w(3)).to include("3 = 3x3 board")
    expect(cli_output %w(3)).to include("4 = 4x4 board")
  end

  it "given an invalid option should say is invalid" do
    expect(cli_output %w(0 3)).to include('"0" is not a valid option!')
  end

  it "given an invalid option should repeat the valid ones" do
    expect(cli_output %w(0 3)).to include('try one of ["3", "4"]')
  end

  def ask_board_type(commands)
    input = StringIO.new(commands.push("").join("\n"))
    out = StringIO.new
    option = create(input, out)
    option.get
  end

  it "should return a ThreeByThreeBoard if answering 3" do
    expect(ask_board_type %w(3)).to be_an_instance_of(Boards::ThreeByThreeBoard)
  end

  it "should return a FourByFourBoard if answering 4" do
    expect(ask_board_type %w(4)).to be_an_instance_of(Boards::FourByFourBoard)
  end
end

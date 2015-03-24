require 'cli_options'
require 'three_by_three_board'

class BoardTypeOption
  def initialize(input, output)
    @option = CliOptions.new(input, output)
  end

  def ask
    option.ask_for_one(
      "What will be the size of the board?",
      {"3" => "3x3 board"})

    ThreeByThreeBoard.new
  end

  private
  attr_accessor :option
end

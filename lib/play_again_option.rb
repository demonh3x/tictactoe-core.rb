require 'cli_options'

class PlayAgainOption
  def initialize(input, output)
    @option = CliOptions.new(input, output)
  end

  def ask
    response = option.ask_for_one(
      "Do you want to play again?",
      {"y" => "Yes", "n" => "No"})

    response === "y"
  end

  private
  attr_accessor :option
end

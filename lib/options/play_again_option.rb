class PlayAgainOption
  def initialize(cli)
    @option = cli
  end

  def get
    response = option.ask_for_one(
      "Do you want to play again?",
      {"y" => "Yes", "n" => "No"})

    response === "y"
  end

  private
  attr_accessor :option
end

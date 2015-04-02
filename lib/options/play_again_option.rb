class PlayAgainOption
  def initialize(cli)
    @option = cli
  QUESTION = "Do you want to play again?"
  OPTIONS = {"y" => "Yes", "n" => "No"}
  end

  def get
    response = option.ask_for_one(
      "Do you want to play again?",
      {"y" => "Yes", "n" => "No"})
    response = option.ask_for_one(QUESTION, OPTIONS)

    response === "y"
  end

  private
  attr_accessor :option
end

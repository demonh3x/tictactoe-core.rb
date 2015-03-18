require 'cli_options'

class PlayersOption
  def initialize(input, output, random)
    @input = input
    @output = output
    @random = random
    @option = CliOptions.new(input, output)
  end

  def ask
    response = option.ask_for_one(
      "Who will play?",
      {
        "hvh" => "Human VS Human",
        "hvc" => "Human VS Computer",
        "cvh" => "Computer VS Human",
        "cvc" => "Computer VS Computer",
      })
    
    case response
    when "hvh" then [human(:x), human(:o)]
    when "hvc" then [human(:x), computer(:o)]
    when "cvh" then [computer(:x), human(:o)]
    when "cvc" then [computer(:x), computer(:o)]
    end
  end

  private
  attr_accessor :input, :output, :random, :option

  def human(mark)
    CliPlayer.new(mark, input, output)
  end

  def computer(mark)
    RandomPlayer.new(mark, random)
  end
end

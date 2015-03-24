require 'cli_options'
require 'cli_player'
require 'perfect_player'

class PlayersOption
  def initialize(input, output)
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
    when "hvc" then [human(:x), computer(:o, :x)]
    when "cvh" then [computer(:x, :o), human(:o)]
    when "cvc" then [computer(:x, :o), computer(:o, :x)]
    end
  end

  private
  attr_reader :input, :output, :random, :option

  def human(mark)
    CliPlayer.new(mark, input, output)
  end

  def computer(mark, opponent)
    PerfectPlayer.new(mark, opponent)
  end
end

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
        "1" => "Human VS Human",
        "2" => "Human VS Computer",
        "3" => "Computer VS Human",
        "4" => "Computer VS Computer",
      })
    
    case response
    when "1" then [human(:x), human(:o)]
    when "2" then [human(:x), computer(:o, :x)]
    when "3" then [computer(:x, :o), human(:o)]
    when "4" then [computer(:x, :o), computer(:o, :x)]
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

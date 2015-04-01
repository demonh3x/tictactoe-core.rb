require 'cli_options'
require 'players/cli_player'
require 'perfect_player'

class PlayersSelection
  def initialize(asker)
    @asker = asker
  end

  def read
    response = asker.ask_for_one(
      "Who will play?",
      {
        "1" => "Human VS Human",
        "2" => "Human VS Computer",
        "3" => "Computer VS Human",
        "4" => "Computer VS Computer",
      })

    case response
    when "1" then [:human, :human]
    when "2" then [:human, :computer]
    when "3" then [:computer, :human]
    when "4" then [:computer, :computer]
    end
  end

  private
  attr_reader :asker
end

class PlayersFactory
  def initialize(input, output, random)
    @input = input
    @output = output
    @random = random
  end

  def create(types)
    (marks.zip types).map do |mark, type|
      constructor(type).call(mark)
    end
  end

  private
  attr_reader :input, :output, :random

  MARKS = [:x, :o]
  def marks
    MARKS
  end

  def constructors
    @constructors ||= {
      :human => lambda do |mark|
        CliPlayer.new(mark, input, output)
      end,
      :computer => lambda do |mark|
        PerfectPlayer.new(mark, opponent(mark), random)
      end
    }
  end

  def constructor(type)
    constructors[type]
  end

  def opponent(mark)
    next_mark_index = (marks.index(mark) +1) % marks.length
    marks[next_mark_index]
  end
end

class PlayersOption
  def initialize(selection, factory)
    @selection = selection
    @factory = factory
  end

  def get
    factory.create(selection.read)
  end

  private
  attr_reader :selection, :factory
end

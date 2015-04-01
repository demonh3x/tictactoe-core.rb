require 'cli_options'
require 'boards/three_by_three_board'
require 'boards/four_by_four_board'

class BoardTypeSelection
  def initialize(asker)
    @asker = asker
  end

  def read
    response = asker.ask_for_one(
      "What will be the size of the board?",
      {
        "3" => "3x3 board",
        "4" => "4x4 board",
      })

    Integer(response)
  end

  private
  attr_reader :asker
end

class BoardTypeFactory
  def create(side_size)
    case side_size
    when 3 then ThreeByThreeBoard.new
    when 4 then FourByFourBoard.new
    end
  end
end

class BoardTypeOption
  def initialize(selection, factory)
    @selection = selection
    @factory = factory
  end

  def get
    factory.create(selection.read)
  end

  private
  attr_accessor :selection, :factory
end

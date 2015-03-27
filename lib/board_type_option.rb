require 'cli_options'
require 'three_by_three_board'

class BoardTypeSelection
  def initialize(asker)
    @asker = asker
  end

  def read
    asker.ask_for_one(
      "What will be the size of the board?",
      {"3" => "3x3 board"})

    :three_by_three
  end

  private
  attr_reader :asker
end

class BoardTypeFactory
  def create(type)
    ThreeByThreeBoard.new
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

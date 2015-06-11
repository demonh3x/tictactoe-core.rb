dirname = File.expand_path(File.dirname(File.dirname(__FILE__))) + "/lib"
$LOAD_PATH.unshift(dirname) unless $LOAD_PATH.include?(dirname)

require 'tictactoe/game'
require 'tictactoe/players/factory'
require 'tictactoe/players/perfect_computer'

class TestRun
  attr_reader :board_size, :random

  def initialize(board_size, random = Random.new)
    @board_size = board_size
    @random = random
  end

  def game_winner
    factory = Tictactoe::Players::Factory.new
    factory.register(:computer, lambda { |mark| Tictactoe::Players::PerfectComputer.new(mark, random) })

    game = Tictactoe::Game.new(factory, board_size, :computer, :computer)

    game.tick until game.is_finished?
    game.winner
  end
end

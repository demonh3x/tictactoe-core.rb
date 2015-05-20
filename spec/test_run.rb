dirname = File.expand_path(File.dirname(File.dirname(__FILE__))) + "/lib"
$LOAD_PATH.unshift(dirname) unless $LOAD_PATH.include?(dirname)

require 'tictactoe/game'

class TestRun
  attr_reader :board_size, :random
  def initialize(board_size, random = Random.new)
    @board_size = board_size
    @random = random
  end

  def game_winner
    ttt = Tictactoe::Game.new(board_size, :computer, :computer, random)
    ttt.user_moves = nil
    ttt.tick() until ttt.is_finished?
    ttt.winner
  end
end

require 'timeout'

RSpec.describe 'Performance', :integration => true do
  def game_winner(board_size)
    ttt = Tictactoe::Game.new(board_size, :computer, :computer, nil)
    ttt.tick() until ttt.is_finished?
    ttt.winner
  end

  it 'runs a full 3x3 game in less than 1 second' do
    Timeout::timeout(1) {
      game_winner(3)
    }
  end

  it 'runs a full 4x4 game in less than 3 seconds' do
    Timeout::timeout(3) {
      game_winner(4)
    }
  end
end

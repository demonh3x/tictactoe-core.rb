require 'spec_helper'
require 'reproducible_random'
require 'tictactoe/game'

RSpec.describe "Properties", :properties => true do
  def game_winner(board_size, random)
    ttt = Tictactoe::Game.new(board_size, :computer, :computer, nil, random)
    ttt.tick() until ttt.is_finished?
    ttt.winner
  end

  10.times do |n|
    it 'two perfect players in a 4x4 board ends up in a draw' do
      random = ReproducibleRandom.new

      random.print
      puts n

      expect(game_winner 4, random).to eq(nil)
    end
  end

  10.times do |n|
    it 'two perfect players in a 3x3 board ends up in a draw' do
      random = ReproducibleRandom.new

      random.print
      puts n

      expect(game_winner 3, random).to eq(nil)
    end
  end
end

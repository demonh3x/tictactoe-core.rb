require 'spec_helper'
require 'tictactoe/game'

RSpec.describe "Properties", :properties => true do
  class RepeteableRandom
    attr_accessor :sequence, :progress

    def initialize(sequence = 20.times.map{Random.new.rand})
      @sequence = sequence
      @progress = sequence.cycle
    end

    def rand
      progress.next
    end

    def print
      puts "RepeteableRandom sequence: #{sequence.to_s}"
    end
  end

  def game_winner(board_size, random)
    ttt = Tictactoe::Game.new(random)
    ttt.set_board_size(board_size)
    ttt.set_player_x(:computer)
    ttt.set_player_o(:computer)

    ttt.tick(nil) until ttt.is_finished?
    ttt.winner
  end

  1000.times do |n|
    it 'two perfect players in a 4x4 board ends up in a draw' do
      random = RepeteableRandom.new

      random.print
      puts n

      expect(game_winner 4, random).to eq(nil)
    end
  end

  1000.times do |n|
    it 'two perfect players in a 3x3 board ends up in a draw' do
      random = RepeteableRandom.new

      random.print
      puts n

      expect(game_winner 3, random).to eq(nil)
    end
  end
end

require 'spec_helper'
require 'core/game'
require 'core/state'
require 'boards/four_by_four_board'
require 'boards/three_by_three_board'
require 'players/ai/perfect_player'
require 'players/ai/random_chooser'

RSpec.describe "Properties", :properties => true do
  class UI
    attr_accessor :state

    def update(state)
      @state = state
    end
  end

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

  def player(mark, opponent, random)
    Players::AI::PerfectPlayer.new(mark, opponent, Players::AI::RandomChooser.new(random))
  end

  def game_winner(board, random)
    ui = UI.new()
    game = Core::Game.new(
      Core::State.new(board),
      ui,
      [player(:x, :o, random), player(:o, :x, random)] 
    )

    game.start
    game.step until game.finished?

    ui.state.when_finished {|w| w}
  end

  1000.times do |n|
    it 'two perfect players in a 4x4 board ends up in a draw' do
      random = RepeteableRandom.new

      random.print
      puts n

      expect(game_winner Boards::FourByFourBoard.new, random).to eq(nil)
    end
  end

  1000.times do |n|
    it 'two perfect players in a 3x3 board ends up in a draw' do
      random = RepeteableRandom.new

      random.print
      puts n

      expect(game_winner Boards::ThreeByThreeBoard.new, random).to eq(nil)
    end
  end
end

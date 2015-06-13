require 'spec_helper'
require 'reproducible_random'
require 'test_run'

RSpec.describe "Properties", :properties => true do
  0.times do |n|
    it 'two perfect players in a 4x4 board ends up in a draw' do
      random = ReproducibleRandom.new

      random.print
      puts n

      expect(TestRun.new(4, random).game_winner).to eq(nil)
    end
  end

  0.times do |n|
    it 'two perfect players in a 3x3 board ends up in a draw' do
      random = ReproducibleRandom.new

      random.print
      puts n

      expect(TestRun.new(3, random).game_winner).to eq(nil)
    end
  end
end

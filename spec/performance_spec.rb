require 'spec_helper'
require 'timeout'
require 'test_run'

RSpec.describe 'Performance', :integration => true do
  it 'runs a full 3x3 game in less than 1 second' do
    Timeout::timeout(1) {
      TestRun.new(3).game_winner
    }
  end

  it 'runs a full 4x4 game in less than 10 seconds' do
    Timeout::timeout(10) {
      TestRun.new(4).game_winner
    }
  end
end

require 'spec_helper'
require 'players/ai/random_strategy_player'

RSpec.describe Players::AI::RandomStrategyPlayer do
  it "has a mark" do
    expect(described_class.new(:x, nil, nil).mark).to eq(:x)
    expect(described_class.new(:o, nil, nil).mark).to eq(:o)
  end

  describe 'given a strategy' do
    describe 'when asking for a location' do
      def expect_received(state)
        strategy = spy(:call => [1, 2])
        random = spy(:rand => 0.0)
        player = described_class.new(:x, strategy, random)

        player.ask_for_location(state)

        expect(strategy).to have_received(:call).with(state)
      end

      it 'should have sent the state to the strategy' do
        expect_received(:state_a)
        expect_received(:state_b)
      end
    end

    describe 'that returns only one location' do
      it 'should select it no matter the random' do
        strategy = spy(:call => [5])
        random = spy(:rand => 0.9)
        player = described_class.new(:x, strategy, random)

        expect(player.ask_for_location(nil)).to eq(5)
      end
    end

    describe 'that returns two locations' do
      it 'should select the first one when the random goes in the first half' do
        strategy = spy(:call => [1, 2])
        random = spy(:rand => 0.0)
        player = described_class.new(:x, strategy, random)

        expect(player.ask_for_location(nil)).to eq(1)
      end

      it 'should select the second one when the random goes in the second half' do
        strategy = spy(:call => [1, 2])
        random = spy(:rand => 0.9)
        player = described_class.new(:x, strategy, random)

        expect(player.ask_for_location(nil)).to eq(2)
      end
    end
  end
end

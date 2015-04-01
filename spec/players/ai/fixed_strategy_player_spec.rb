require 'players/ai/fixed_strategy_player'

RSpec.describe FixedStrategyPlayer do
  it 'has a mark' do
    expect(described_class.new(:x, nil).mark).to eq(:x)
    expect(described_class.new(:o, nil).mark).to eq(:o)
  end

  describe 'given a strategy' do
    describe 'when asking for a location' do
      def expect_received(state)
        strategy = spy(:call => [1, 2])
        player = described_class.new(:x, strategy)

        player.ask_for_location(state)

        expect(strategy).to have_received(:call).with(state)
      end

      it 'should have sent the state to the strategy' do
        expect_received(:state_a)
        expect_received(:state_b)
      end
    end

    describe 'that returns two locations' do
      it 'should select the first one' do
        strategy = spy(:call => [1, 2])
        player = described_class.new(:x, strategy)

        expect(player.ask_for_location(nil)).to eq(1)
      end
    end

    describe 'that returns only one location' do
      it 'should select it' do
        strategy = spy(:call => [5])
        player = described_class.new(:x, strategy)

        expect(player.ask_for_location(nil)).to eq(5)
      end
    end
  end
end

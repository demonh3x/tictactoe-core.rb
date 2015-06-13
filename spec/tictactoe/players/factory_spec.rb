require 'spec_helper'
require 'tictactoe/players/factory'

RSpec.describe Tictactoe::Players::Factory do
  class ComputerFake
    attr_reader :mark

    def initialize(mark)
      @mark = mark
    end
  end

  let(:computer_factory) do
    lambda{|mark| ComputerFake.new(mark)}
  end
  let(:factory) do
    factory = described_class.new()
    factory.register(:computer, computer_factory)
    factory
  end

  it 'creates a computer player' do
    computer_player = factory.create(:computer, :x)

    expect(computer_player).to be_a(ComputerFake)
    expect(computer_player.mark).to eq(:x)
  end

  class HumanFake
    attr_reader :mark

    def initialize(mark)
      @mark = mark
    end
  end

  it 'creates a human computer after being registered' do
    human_factory = lambda{|mark| HumanFake.new(mark)}
    factory.register(:human, human_factory)
    human_player = factory.create(:human, :o)

    expect(human_player).to be_a(HumanFake)
    expect(human_player.mark).to eq(:o)
  end

  it 'raises a message when no factory is available for that type' do
    expect{factory.create(:unknown_type, :o)}.to raise_error("No factory has been defined for type: unknown_type")
  end
end

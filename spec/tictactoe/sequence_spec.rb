require 'tictactoe/sequence'

RSpec.describe Tictactoe::Sequence do
  it 'has the first value' do
    expect(described_class.new([:x, :o]).first.value).to eq(:x)
  end

  it 'has the second value' do
    expect(described_class.new([:x, :o]).first.next.value).to eq(:o)
  end

  it 'cycles when reaches the end' do
    expect(described_class.new([:x, :o]).first.next.next.value).to eq(:x)
  end

  it 'can handle 3 nodes' do
    expect(described_class.new([0, 1, 2]).first.next.next.value).to eq(2)
    expect(described_class.new([0, 1, 2]).first.next.next.next.value).to eq(0)
  end
end

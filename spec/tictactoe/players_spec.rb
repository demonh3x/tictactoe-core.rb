require 'tictactoe/players'

RSpec.describe Tictactoe::Players do
  it 'has the first players mark' do
    expect(described_class.new(:x, :o).first.mark).to eq(:x)
  end

  it 'has the second players mark' do
    expect(described_class.new(:x, :o).first.next.mark).to eq(:o)
  end

  it 'cycles when reaches the end' do
    expect(described_class.new(:x, :o).first.next.next.mark).to eq(:x)
  end
end

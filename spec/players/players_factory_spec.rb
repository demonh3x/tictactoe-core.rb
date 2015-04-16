require 'spec_helper'
require 'players/players_factory'

RSpec.describe PlayersFactory do
  let(:factory) { described_class.new(:input, :output, :random) }

  def create_single(type)
    factory.create([type])[0]
  end

  it 'can create a human player' do
    expect(create_single(:human)).to be_an_instance_of Players::CliPlayer
  end

  it 'can create a computer player' do
    expect(create_single(:computer)).to be_an_instance_of Players::AI::RandomStrategyPlayer
  end

  def create(types)
    factory.create(types)
  end

  it 'assigns x as the mark for the first player' do
    players = create([:human, :human])
    expect(players[0].mark).to eq(:x)
  end

  it 'assigns o as the mark for the second player' do
    players = create([:computer, :computer])
    expect(players[1].mark).to eq(:o)
  end
end

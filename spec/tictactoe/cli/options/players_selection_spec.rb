require 'spec_helper'
require 'tictactoe/cli/options/players_selection'

RSpec.describe Tictactoe::Cli::Options::PlayersSelection do
  it 'when reading, asks the question' do
    asker = spy()
    described_class.new(asker).read
    expect(asker).to have_received(:ask_for_one).with(
      "Who will play?",
      {
        "1" => "Human VS Human",
        "2" => "Human VS Computer",
        "3" => "Computer VS Human",
        "4" => "Computer VS Computer",
      }
    )
  end
  
  def expect_players_selected(selection, expected_players)
    actual_players = described_class.new(spy(:ask_for_one => selection)).read
    expect(actual_players).to eq(expected_players)
  end

  it 'when selecting 1, is human vs human' do
    expect_players_selected "1", [:human, :human]
  end

  it 'when selecting 2, is human vs computer' do
    expect_players_selected "2", [:human, :computer]
  end

  it 'when selecting 3, is computer vs human' do
    expect_players_selected "3", [:computer, :human]
  end
  
  it 'when selecting 4, is computer vs computer' do
    expect_players_selected "4", [:computer, :computer]
  end
end

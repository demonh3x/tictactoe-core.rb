require 'spec_helper'
require 'tictactoe/cli/options/board_type_selection'

RSpec.describe Tictactoe::Cli::Options::BoardTypeSelection do
  it 'when reading, asks the question' do
    asker = spy()
    described_class.new(asker).read
    expect(asker).to have_received(:ask_for_one).with(
      "What will be the size of the board?",
      {"3" => "3x3 board", "4" => "4x4 board"}
    )
  end
  
  def expect_size_selected(selection, expected_size)
    actual_size = described_class.new(spy(:ask_for_one => selection)).read
    expect(actual_size).to eq(expected_size)
  end

  it 'when selecting an option, returns it as an integer' do
    expect_size_selected("3", 3)
    expect_size_selected("4", 4)
  end
end

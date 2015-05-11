require 'spec_helper'
require 'tictactoe/cli/options/option'

RSpec.describe Options::Option do
  before(:each) do
    @selection = spy(:read => :selection_value)
    @factory = spy(:create => :created_value)
    @option = described_class.new @selection, @factory
  end

  describe "when getting" do
    it 'reads the selection' do
      @option.get
      expect(@selection).to have_received(:read)
    end

    it 'sends the selection to the factory' do
      @option.get
      expect(@factory).to have_received(:create).with(:selection_value)
    end

    it 'returns the creation from the factory' do
      expect(@option.get).to eq(:created_value)
    end
  end
end

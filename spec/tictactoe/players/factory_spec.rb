require 'tictactoe/players/factory'

RSpec.describe Tictactoe::Players::Factory do
  class ComputerFake
    attr_reader :mark

    def initialize(mark)
      @mark = mark
    end
  end

  let(:factory){described_class.new(lambda{|mark| ComputerFake.new(mark)})}

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
    factory.register_human_factory(lambda{|mark| HumanFake.new(mark)})
    human_player = factory.create(:human, :o)

    expect(human_player).to be_a(HumanFake)
    expect(human_player.mark).to eq(:o)
  end
end

require 'tictactoe/players/computer'

RSpec.describe Tictactoe::Players::Computer do
  class IntelligenceSpy
    attr_reader :received_state, :received_mark

    def initialize(moves)
      @moves = moves
    end

    def desired_moves(state, mark)
      @received_state = state
      @received_mark = mark
      @moves
    end
  end

  class ChooseFirst
    def choose_one(list)
      list.first
    end
  end

  def create(mark, intelligence = IntelligenceSpy.new([1, 2, 3]), chooser = ChooseFirst.new)
    described_class.new(mark, intelligence, chooser)
  end

  it 'has a mark' do
    computer = create(:x)
    expect(computer.mark).to eq(:x)
  end

  it 'is ready to move' do
    computer = create(:x)
    expect(computer.ready_to_move?).to eq(true)
  end

  it 'can make a move' do
    intelligence =  IntelligenceSpy.new([1, 2, 3])
    computer = create(:x, intelligence, ChooseFirst.new)

    expect(computer.get_move(:state)).to eq (1)
    expect(intelligence.received_state).to eq (:state)
    expect(intelligence.received_mark).to eq (:x)
  end
end

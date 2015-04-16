require 'spec_helper'
require 'boards/board_type_factory'

RSpec.describe Boards::BoardTypeFactory do
  def create(side_size)
    described_class.new.create(side_size)
  end

  it 'given 3 returns a ThreeByThreeBoard' do
    expect(create(3)).to be_an_instance_of(Boards::ThreeByThreeBoard)
  end
  
  it 'given 4 returns a FourByFourBoard' do
    expect(create(4)).to be_an_instance_of(Boards::FourByFourBoard)
  end
end

require 'spec_helper'
require 'players/ai/random_chooser'

RSpec.describe Players::AI::RandomChooser, :ignored => true do
  def choose_with(random_value, list)
    random = spy :rand => random_value
    described_class.new(random).choose_one list
  end
  
  describe 'given only one option' do
    describe 'should choose it no matter the random value'  do
      it 'for example: minimum random value' do
        expect(choose_with 0.0, [1]).to eq 1
      end

      it 'for example: maximum random value' do
        expect(choose_with 0.99, [1]).to eq 1
      end
    end
  end

  describe 'given two options' do
    it 'chooses the first one when the random is less than a half' do
        expect(choose_with 0.0, [1, 2]).to eq 1
        expect(choose_with 0.4, [1, 2]).to eq 1
    end

    it 'chooses the second one when the random is more than a half' do
        expect(choose_with 0.5, [1, 2]).to eq 2
        expect(choose_with 0.99, [1, 2]).to eq 2
    end
  end
    
  describe 'given three options' do
    it 'chooses the first one when the random is less than a third' do
        expect(choose_with 0.0, [1, 2, 3]).to eq 1
        expect(choose_with 0.3, [1, 2, 3]).to eq 1
    end

    it 'chooses the second one when the random is between a third and two thirds' do
        expect(choose_with 0.4, [1, 2, 3]).to eq 2
        expect(choose_with 0.6, [1, 2, 3]).to eq 2
    end

    it 'chooses the third one when the random is more than two thirds' do
        expect(choose_with 0.7, [1, 2, 3]).to eq 3
        expect(choose_with 0.9, [1, 2, 3]).to eq 3
    end
  end
end

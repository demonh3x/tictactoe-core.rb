require 'spec_helper'
require 'core/game'

RSpec.describe Core::Game do
  class FinishedStateStub
    def when_finished
      yield
    end
  end

  it 'is finished if the state is finished' do
    game = described_class.new FinishedStateStub.new, spy, [spy, spy]

    expect(game.finished?).to eq(true)
  end

  class NotFinishedStateStub
    def when_finished
    end
  end

  it 'is not finished if the state is not finished' do
    game = described_class.new NotFinishedStateStub.new, spy, [spy, spy]

    expect(game.finished?).to eq(false)
  end

  def expect_to_be_updated_with(updatee, state)
    expect(updatee).to have_received(:update).with(state).at_least(1).times
  end

  it 'when starting, updates the colaborators with the initial state' do
    initial_state = spy
    ui = spy
    first_player = spy
    second_player = spy
    game = described_class.new initial_state, ui, [first_player, second_player]

    game.start

    expect_to_be_updated_with(ui, initial_state)
    expect_to_be_updated_with(first_player, initial_state)
    expect_to_be_updated_with(second_player, initial_state)
  end

  describe 'at the first step' do
    it 'if the first player is not ready to move, does not ask for the move' do
      initial_state = spy
      first_player = spy :is_ready_to_move? => false
      game = described_class.new initial_state, spy, [first_player, spy]

      game.start
      game.step

      expect(first_player).to have_received(:is_ready_to_move?).at_least(1).times
      expect(first_player).not_to have_received(:play)
    end

    describe 'if the first player is ready to move' do
      it 'asks for the move' do
        initial_state = spy
        first_player = spy :is_ready_to_move? => true
        game = described_class.new initial_state, spy, [first_player, spy]

        game.start
        game.step

        expect(first_player).to have_received(:is_ready_to_move?).at_least(1).times
        expect(first_player).to have_received(:play).at_least(1).times
      end

      it 'updates the colaborators with the move' do
        first_player = spy :is_ready_to_move? => true, :play => :state_after_first_player
        second_player = spy
        ui = spy
        game = described_class.new spy, ui, [first_player, second_player]

        game.start
        game.step

        expect_to_be_updated_with(ui, :state_after_first_player)
        expect_to_be_updated_with(first_player, :state_after_first_player)
        expect_to_be_updated_with(second_player, :state_after_first_player)
      end
    end
  end

  describe 'at the second step' do
    it 'updates the colaborators with the move' do
      ui = spy
      first_player = spy
      second_player = spy :is_ready_to_move? => true, :play => :state_after_second_player
      game = described_class.new spy, ui, [first_player, second_player]

      game.start
      game.step
      game.step

      expect_to_be_updated_with(ui, :state_after_second_player)
      expect_to_be_updated_with(first_player, :state_after_second_player)
      expect_to_be_updated_with(second_player, :state_after_second_player)
    end
  end
end

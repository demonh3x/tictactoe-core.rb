require 'spec_helper'
require 'core/game'

RSpec.describe "Game" do
  class FinishedStateStub
    def when_finished
      yield
    end
  end

  it 'is finished if the state is finished' do
    game = Game.new FinishedStateStub.new, spy, [spy, spy]

    expect(game.finished?).to eq(true)
  end

  class NotFinishedStateStub
    def when_finished
    end
  end

  it 'is not finished if the state is not finished' do
    game = Game.new NotFinishedStateStub.new, spy, [spy, spy]

    expect(game.finished?).to eq(false)
  end

  it 'when starting, updates the UI with the initial state' do
    initial_state = spy
    ui = spy
    game = Game.new initial_state, ui, [spy, spy]

    game.start

    expect(ui).to have_received(:update).with(initial_state).at_least(1).times
  end

  it 'at the first step, asks the first player' do
    initial_state = spy
    first_player = spy
    game = Game.new initial_state, spy, [first_player, spy]

    game.start
    game.step

    expect(first_player).to have_received(:play).with(initial_state).at_least(1).times
  end

  it 'the state after the first player is sent to the next player' do
    first_player = spy :play => :state_after_first_player
    second_player = spy
    game = Game.new spy, spy, [first_player, second_player]

    game.start
    game.step
    game.step

    expect(second_player).to have_received(:play).with(:state_after_first_player)
  end

  it 'the UI is updated with the first player state' do
    first_player = spy :play => :state_after_first_player
    ui = spy
    game = Game.new spy, ui, [first_player, spy]

    game.start
    game.step

    expect(ui).to have_received(:update).with(:state_after_first_player)
  end

  it 'the state after the second player is sent to the next player' do
    first_player = spy 
    second_player = spy :play => :state_after_second_player
    game = Game.new spy, spy, [first_player, second_player]

    game.start
    game.step
    game.step
    game.step

    expect(first_player).to have_received(:play).with(:state_after_second_player)
  end

  it 'at the second step, the UI is updated with the new state' do
    second_player = spy :play => :state_after_second_player
    ui = spy
    game = Game.new spy, ui, [spy, second_player]

    game.start
    game.step
    game.step

    expect(ui).to have_received(:update).with(:state_after_second_player)
  end
end

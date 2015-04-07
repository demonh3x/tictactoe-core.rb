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
    state = spy
    first_player = spy
    game = Game.new state, spy, [first_player, spy]

    game.start
    game.step

    expect(first_player).to have_received(:ask_for_location).with(state).at_least(1).times
  end

  it 'at the first step, the first player decision is used to calculate the next step' do
    state = spy
    first_player = spy :ask_for_location => :first_player_decision, :mark => :first_player_mark
    game = Game.new state, spy, [first_player, spy]

    game.start
    game.step

    expect(state).to have_received(:make_move).with(:first_player_decision, :first_player_mark)
  end

  it 'at the first step, the UI is updated with the new state' do
    state = spy :make_move => :new_state
    ui = spy
    game = Game.new state, ui, [spy, spy]

    game.start
    game.step

    expect(ui).to have_received(:update).with(:new_state)
  end

  it 'at the second step, asks the second player' do
    state = spy
    second_player = spy
    game = Game.new state, spy, [spy, second_player]

    game.start
    game.step
    game.step

    expect(second_player).to have_received(:ask_for_location).with(state).at_least(1).times
  end

  it 'at the second step, the second player decision is used to calculate the next step' do
    state = spy
    second_player = spy :ask_for_location => :second_player_decision, :mark => :second_player_mark
    game = Game.new state, spy, [spy, second_player]

    game.start
    game.step
    game.step

    expect(state).to have_received(:make_move).with(:second_player_decision, :second_player_mark)
  end

  it 'at the second step, the UI is updated with the new state' do
    state = spy(:make_move => spy(:make_move => :new_state))
    ui = spy
    game = Game.new state, ui, [spy, spy]

    game.start
    game.step
    game.step

    expect(ui).to have_received(:update).with(:new_state)
  end
end

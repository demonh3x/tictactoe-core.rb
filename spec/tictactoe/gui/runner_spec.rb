require 'spec_helper'
require 'tictactoe/gui/runner'

RSpec.describe Tictactoe::Gui::Runner, :integration => true, :gui => true do
  def tick(gui)
    find(gui, "timer").timeout
  end

  def click_cell(gui, index)
    find(gui, "cell_#{index}").click
  end

  it 'creates a Qt application' do
    described_class.new
    app_count = ObjectSpace.each_object(Qt::Application).count
    expect(app_count).to be > 0
  end

  it 'running a full game between two humans on a 3 by 3 board' do
    app = described_class.new

    find(app.menu, "board_3").click
    find(app.menu, "x_human").click
    find(app.menu, "o_human").click
    find(app.menu, "start").click
    game = app.games.first

    click_cell(game, 0) #x
    click_cell(game, 3) #o
    click_cell(game, 1) #x
    click_cell(game, 4) #o
    expect(find(game, "result").text).to eq(nil)
    click_cell(game, 2) #x
    expect(find(game, "result").text).to eq('Player X has won.')
  end

  it 'running a full game between two humans on a 4 by 4 board' do
    app = described_class.new

    find(app.menu, "board_4").click
    find(app.menu, "x_human").click
    find(app.menu, "o_human").click
    find(app.menu, "start").click
    game = app.games.first

    click_cell(game, 0) #x
    click_cell(game, 4) #o
    click_cell(game, 1) #x
    click_cell(game, 5) #o
    click_cell(game, 2) #x
    click_cell(game, 6) #o
    expect(find(game, "result").text).to eq(nil)
    click_cell(game, 3) #x
    expect(find(game, "result").text).to eq('Player X has won.')
  end

  it 'running a full game between two computers on a 3 by 3 board' do
    app = described_class.new

    find(app.menu, "board_3").click
    find(app.menu, "x_computer").click
    find(app.menu, "o_computer").click
    find(app.menu, "start").click
    game = app.games.first

    8.times do
      tick(game)
    end
    expect(find(game, "result").text).to eq(nil)
    tick(game)
    expect(find(game, "result").text).to eq('It is a draw.')
  end
end

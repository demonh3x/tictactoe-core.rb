require 'spec_helper'
require 'tictactoe/gui/runner'

RSpec.describe Tictactoe::Gui::MenuWindow, :integration => true, :gui => true do
  before(:each) do
    Qt::Application.new(ARGV)
  end

  it 'has the default options selected' do
    menu = described_class.new(spy())
    expect(find(menu, "x_human").checked).to eq(true)
    expect(find(menu, "o_human").checked).to eq(true)
    expect(find(menu, "board_3").checked).to eq(true)
  end

  it 'sends the default options to the callback' do
    start_callback = spy()
    menu = described_class.new(start_callback)
    find(menu, "start").click
    expect(start_callback).to have_received(:call).with({
      :x => :human,
      :o => :human,
      :board => 3,
    })
  end

  describe 'sends the different options when selected' do
    it 'x is computer, o is human, board of size 4' do
      start_callback = spy()
      menu = described_class.new(start_callback)
      find(menu, "x_computer").click
      find(menu, "o_human").click
      find(menu, "board_4").click
      find(menu, "start").click
      expect(start_callback).to have_received(:call).with({
        :x => :computer,
        :o => :human,
        :board => 4,
      })
    end

    it 'x is human, o is computer, board of size 3' do
      start_callback = spy()
      menu = described_class.new(start_callback)
      find(menu, "x_human").click
      find(menu, "o_computer").click
      find(menu, "board_3").click
      find(menu, "start").click
      expect(start_callback).to have_received(:call).with({
        :x => :human,
        :o => :computer,
        :board => 3,
      })
    end
  end
end

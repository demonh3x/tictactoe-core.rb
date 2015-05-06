require 'spec_helper'

RSpec.describe UIs::Gui::Runner, :integration => true do
  def click_cell(gui, index)
    find(gui, "timer").timeout
    find(gui, "cell_#{index}").click
  end

  it 'running a full game between two humans' do
    gui = UIs::Gui::Runner.new.gui
    click_cell(gui, 0)
    click_cell(gui, 3)
    click_cell(gui, 1)
    click_cell(gui, 4)
    click_cell(gui, 2)
    expect(find(gui, "result").text).to eq('x has won')
  end
end

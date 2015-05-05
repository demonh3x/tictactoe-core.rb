require 'spec_helper'

RSpec.describe UIs::Gui::Runner, :integration => true do
  it 'running a full game' do
    gui = UIs::Gui::Runner.new.gui
    find(gui, "cell_0").click
    find(gui, "cell_3").click
    find(gui, "cell_1").click
    find(gui, "cell_4").click
    find(gui, "cell_2").click
    expect(find(gui, "result").text).to eq('x has won')
  end
end

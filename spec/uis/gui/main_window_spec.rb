require 'spec_helper'
require 'uis/gui/runner'

RSpec.describe UIs::Gui::MainWindow do
  it 'is a widget' do
    gui = described_class.new(spy())
    expect(gui).to be_kind_of(Qt::Widget)
    expect(gui.parent).to be_nil
    expect(gui.object_name).to eq("main_window")
  end

  it 'creates a Qt application' do
    described_class.new(spy())
    app_count = ObjectSpace.each_object(Qt::Application).count
    expect(app_count).to be > 0
  end

  RSpec::Matchers.define :have_widged_named do |expected|
    match do |widget|
      widget.children.any? do |child|
        child.object_name == expected
      end
    end
  end

  def find_cell(gui, index)
    find(gui, "cell_#{index}")
  end

  def expect_to_have_cell(gui, index)
    expect(gui).to have_widged_named "cell_#{index}"
  end

  def expect_result_text(gui, text)
    expect(find(gui, 'result').text).to eq(text)
  end

  it 'has the board cells' do
    tictactoe = spy(:marks => [
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    ])
    gui = described_class.new(tictactoe)
    (0..8).each do |index|
      expect_to_have_cell(gui, index)
    end
  end

  (0..8).each do |index|
    it "when cell #{index} is clicked, interacts with tictactoe" do
      tictactoe = spy()
      gui = described_class.new(tictactoe)
      find_cell(gui, index).click
      expect(tictactoe).to have_received(:tick)
    end
  end

  describe 'after a move, displays the mark in the cell' do
    it 'in cell 0' do
      tictactoe = spy(:marks => [
        :x,  nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
      gui = described_class.new(tictactoe)
      cell = find_cell(gui, 0)
      cell.click
      expect(cell.text).to eq('x')
    end

    it 'in cell 6' do
      tictactoe = spy(:marks => [
        nil, nil, nil,
        nil, nil, nil,
        :x,  nil, nil
      ])
      gui = described_class.new(tictactoe)
      cell = find_cell(gui, 6)
      cell.click
      expect(cell.text).to eq('x')
    end
  end

  it 'has the result widget' do
    gui = described_class.new(spy())
    expect(gui).to have_widged_named("result")
  end

  describe 'after a move shows the result' do
    it 'unless it is not finished' do
      tictactoe = spy({
        :marks => [],
        :is_finished? => false,
      })
      gui = described_class.new(tictactoe)
      find_cell(gui, 0).click
      expect_result_text(gui, nil)
    end

    it 'of winner x' do
      tictactoe = spy({
        :marks => [],
        :is_finished? => true,
        :winner => :x,
      })
      gui = described_class.new(tictactoe)
      find_cell(gui, 0).click
      expect_result_text(gui, 'x has won')
    end

    it 'of winner o' do
      tictactoe = spy({
        :marks => [],
        :is_finished? => true,
        :winner => :o,
      })
      gui = described_class.new(tictactoe)
      find_cell(gui, 0).click
      expect_result_text(gui, 'o has won')
    end

    it 'of a draw' do
      tictactoe = spy({
        :marks => [],
        :is_finished? => true,
        :winner => nil,
      })
      gui = described_class.new(tictactoe)
      find_cell(gui, 0).click
      expect_result_text(gui, 'it is a draw')
    end
  end
end

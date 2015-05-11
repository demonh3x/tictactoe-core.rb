require 'spec_helper'
require 'tictactoe/cli/board_formatter'

RSpec.describe Tictactoe::Cli::BoardFormatter do
  def format(marks)
    described_class.new.format(marks)
  end

  describe "when updating" do
    describe "given a 3x3 empty state" do
      it "prints it without pieces" do
        marks = [
          nil, nil, nil,
          nil, nil, nil,
          nil, nil, nil,
        ]
        expect(format(marks)).to eq(
          "+---+---+---+\n" +
          "| 0 | 1 | 2 |\n" +
          "+---+---+---+\n" +
          "| 3 | 4 | 5 |\n" +
          "+---+---+---+\n" +
          "| 6 | 7 | 8 |\n" +
          "+---+---+---+\n"
        )
      end
    end

    describe "given a 4x4 empty state" do
      it "prints it without pieces" do
        marks = [
          nil, nil, nil, nil,
          nil, nil, nil, nil,
          nil, nil, nil, nil,
          nil, nil, nil, nil,
        ]
        expect(format(marks)).to eq(
          "+---+---+---+---+\n" +
          "| 0 | 1 | 2 | 3 |\n" +
          "+---+---+---+---+\n" +
          "| 4 | 5 | 6 | 7 |\n" +
          "+---+---+---+---+\n" +
          "| 8 | 9 | 10| 11|\n" +
          "+---+---+---+---+\n" +
          "| 12| 13| 14| 15|\n" +
          "+---+---+---+---+\n"
        )
      end
    end

    describe "given a state with some moves" do
      it "prints it with the pieces at the correct position" do
        marks = [
          :X,  nil, :O,
          nil, :O,  :X,
          nil, nil, nil,
        ]
        expect(format(marks)).to eq(
          "+---+---+---+\n" +
          "| X | 1 | O |\n" +
          "+---+---+---+\n" +
          "| 3 | O | X |\n" +
          "+---+---+---+\n" +
          "| 6 | 7 | 8 |\n" +
          "+---+---+---+\n"
        )
      end
    end

    describe "given a finished state" do
      it "with a winner, prints it announcing the winner" do
        marks = [
          :X,  nil, :O,
          nil, :O,  :X,
          :O,  :X,  nil,
        ]
        expect(format(marks)).to eq(
          "+---+---+---+\n" +
          "| X | 1 | O |\n" +
          "+---+---+---+\n" +
          "| 3 | O | X |\n" +
          "+---+---+---+\n" +
          "| O | X | 8 |\n" +
          "+---+---+---+\n"
        )
      end
      
      it "with a draw, prints it announcing the draw" do
        marks = [
          :X, :O, :X,
          :O, :O, :X,
          :X, :X, :O,
        ]
        expect(format(marks)).to eq(
          "+---+---+---+\n" +
          "| X | O | X |\n" +
          "+---+---+---+\n" +
          "| O | O | X |\n" +
          "+---+---+---+\n" +
          "| X | X | O |\n" +
          "+---+---+---+\n"
        )
      end
    end
  end
end

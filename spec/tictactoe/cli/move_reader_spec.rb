require 'spec_helper'
require 'tictactoe/cli/move_reader'

RSpec.describe Tictactoe::Cli::MoveReader do
  let(:input){StringIO.new}
  let(:output){StringIO.new}

  def user_will_send(str)
    input.string += "#{str}\n"
  end

  def reader(available_locations = (0..8).to_a)
    described_class.new(input, output, spy(:available => available_locations))
  end

  describe "when asking for a location" do
    it "prints the message doing it" do
      user_will_send("1")
      reader.get_move!
      expect(output.string).to include("Your turn! Where do you want to play?\n")
    end

    describe "given no input" do
      it "raises an error" do
        expect{reader.get_move!}.to raise_error("No data readed from the CLI input!")
      end
    end

    describe "given an input with no whitespaces" do
      it "reads the location" do
        user_will_send("7")
        expect(reader.get_move!).to eq(7)
      end
    end

    describe "given an input with some whitespaces" do
      it "reads the location" do
        user_will_send("  \t 2 \t ")
        expect(reader.get_move!).to eq(2)
      end
    end

    describe "given an invalid input" do
      it "should try to read again" do
        invalid_input = "::invalid_input::"
        user_will_send(invalid_input)
        user_will_send("4")
        expect(reader.get_move!).to eq(4)
        expect(output.string).to include("Don't understand \"#{invalid_input}\". Please, make sure you use a number.\n")
      end
    end

    describe "given only one available location" do
      it "should try again if not selected" do
        user_will_send("0")
        user_will_send("4")
        expect(reader([4]).get_move!).to eq(4)
        expect(output.string).to include("That location is not available. Please, try another one.\n")
      end
    end
  end
end

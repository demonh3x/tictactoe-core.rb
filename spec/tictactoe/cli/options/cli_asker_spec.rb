require 'spec_helper'
require 'tictactoe/cli/options/cli_asker'

RSpec.describe Tictactoe::Cli::Options::CliAsker do
  describe "given two options, when asking for a selection" do
    before(:each) do
      @out = StringIO.new
      @in = StringIO.new("::selection_1::\n")
      @asker = described_class.new(@in, @out)
      message = "::selection_message::"
      options = {
        "::selection_1::" => "::option_1::",
        "::selection_2::" => "::option_2::",
      }
      @response = @asker.ask_for_one message, options
    end

    it "should ask to select one" do
      expect(@out.string).to include "::selection_message::\n"
    end

    it "should print the options in order" do
      expect(@out.string).to include(
        "::selection_1:: = ::option_1::\n" + 
        "::selection_2:: = ::option_2::\n"
      )
    end

    it "should read the response" do
      expect(@response).to eq "::selection_1::"
    end
  end

  describe "given an invalid response" do
    before(:each) do
      @out = StringIO.new
      @in = StringIO.new("::invalid_response::\n::selection_1::\n")
      @asker = described_class.new(@in, @out)
      options = {
        "::selection_1::" => "::option_1::",
        "::selection_2::" => "::option_2::",
      }
      @response = @asker.ask_for_one "::message::", options
    end

    it "should say thats an invalid response and ask again" do
      expect(@out.string).to include(
        "\"::invalid_response::\" is not a valid option! " + 
        "try one of [\"::selection_1::\", \"::selection_2::\"]"
      )
    end
  end
end

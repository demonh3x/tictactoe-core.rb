module Tictactoe
  module Cli
    module Options
      class PlayAgainOption
        QUESTION = "Do you want to play again?"
        OPTIONS = {"y" => "Yes", "n" => "No"}

        def initialize(asker)
          @asker = asker
        end

        def get
          response = asker.ask_for_one(QUESTION, OPTIONS)

          response === "y"
        end

        private
        attr_accessor :asker
      end
    end
  end
end

module Tictactoe
  module Cli
    module Options
      class BoardTypeSelection
        QUESTION = "What will be the size of the board?"
        OPTIONS = {
          "3" => "3x3 board",
          "4" => "4x4 board",
        }

        def initialize(asker)
          @asker = asker
        end

        def read
          response = asker.ask_for_one(QUESTION, OPTIONS)

          Integer(response)
        end

        private
        attr_reader :asker
      end
    end
  end
end

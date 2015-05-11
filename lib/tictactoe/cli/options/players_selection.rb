module Tictactoe
  module Cli
    module Options
      class PlayersSelection
        QUESTION = "Who will play?"
        OPTIONS = {
          "1" => "Human VS Human",
          "2" => "Human VS Computer",
          "3" => "Computer VS Human",
          "4" => "Computer VS Computer",
        }

        def initialize(asker)
          @asker = asker
        end

        def read
          response = asker.ask_for_one(QUESTION, OPTIONS)

          case response
          when "1" then [:human, :human]
          when "2" then [:human, :computer]
          when "3" then [:computer, :human]
          when "4" then [:computer, :computer]
          end
        end

        private
        attr_reader :asker
      end
    end
  end
end

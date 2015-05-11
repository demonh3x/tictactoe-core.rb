module Tictactoe
  module Cli
    module Options
      class CliAsker
        def initialize(input, output)
          @input = input
          @output = output
        end

        def ask_for_one(selection_message, options)
          print_message selection_message
          print_options options
          read_valid_response options
        end

        private
        attr_accessor :input, :output

        def print_message(selection_message)
          output.puts selection_message
        end

        def print_options(options)
          options.each do |selector, option| 
            output.puts "#{selector} = #{option}"
          end
        end

        def read_valid_response(options)
          response = read_response
          while !options.keys.include? response
            print_invalid_response response, options
            response = read_response
          end
          response
        end

        def read_response
          @input.gets.strip
        end

        def print_invalid_response(response, options)
          @output.puts "\"#{response}\" is not a valid option! try one of #{format options.keys}"
        end

        def format(list)
          "[\"#{list.join("\", \"")}\"]"
        end
      end
    end
  end
end

require 'core/tictactoe'
require 'options/cli_asker'
require 'options/play_again_option'
require 'options/board_type_selection'
require 'options/players_selection'
require 'uis/cli/move_reader'
require 'uis/cli/board_formatter'

module UIs
  module Cli
    class Runner
      attr_reader :input, :output, :random, :ttt, :asker, :board_type, :who_will_play, :play_again

      def initialize(input=$stdin, output=$stdout, random=Random.new)
        @input = input
        @output = output
        @random = random

        @asker = Options::CliAsker.new(input, output)
        @board_type = Options::BoardTypeSelection.new(asker)
        @who_will_play = Options::PlayersSelection.new(asker)
        @play_again = Options::PlayAgainOption.new(asker)
      end

      def run
        begin 
          reset_game
          set_board_size
          set_players

          print_board

          begin
            make_move
            print_board
          end until is_game_finished?

          print_result
        end while play_again?
      end

      private
      def reset_game
        @ttt = Core::TicTacToe.new(random)
      end

      def set_board_size
        ttt.set_board_size(board_type.read)
      end

      def set_players
        players = who_will_play.read
        ttt.set_player_x(players[0])
        ttt.set_player_o(players[1])
      end

      def print_board
        output.puts UIs::Cli::BoardFormatter.new.format(ttt.marks)
      end

      def make_move
        ttt.tick(UIs::Cli::MoveReader.new(input, output, ttt))
      end

      def is_game_finished?
        ttt.is_finished?
      end

      def print_result
        output.puts announcement_of ttt.winner if ttt.is_finished?
      end

      def announcement_of(winner)
        winner.nil?? "It is a draw." : "#{winner.to_s} has won!"
      end

      def play_again?
        play_again.get
      end
    end

    class BoardFormatter
      def format(marks)
        format_board(get_cells(marks))
      end

      private
      def get_cells(marks)
        cells = []
        marks.each_with_index do |mark, index|
          cell = (mark || index).to_s
          cells.push(cell)
        end
        cells
      end

      def format_board(cells)
        side_size = Math.sqrt(cells.size)
        cells_grouped_by_row = cells.each_slice(side_size).to_a

        rows = cells_grouped_by_row.map {|row_cells| row(row_cells) + "\n" }
        separator = horizontal_separator(side_size) + "\n"

        join_surrounding(rows, separator)
      end

      def row(cells)
        cells_with_fixed_width = cells.map{|cell_text| grow(cell_text, cell_width)}
        join_surrounding(cells_with_fixed_width, "|")
      end

      def horizontal_separator(size)
        cell_line = "-" * cell_width
        cell_lines = [cell_line] * size
        join_surrounding(cell_lines, "+")
      end

      def cell_width
        3
      end

      def grow(text, width)
        while text.length < width
          text = " " + text if text.length < width
          text = text + " " if text.length < width
        end

        text
      end

      def join_surrounding(elements, separator)
        separator + elements.join(separator) + separator
      end
    end
  end
end

require 'core/game'
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
        @ttt = Core::Game.new(random)
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
        winner.nil?? "It is a draw." : "Player #{winner.to_s.upcase} has won!"
      end

      def play_again?
        play_again.get
      end
    end
  end
end

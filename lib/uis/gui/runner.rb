require 'Qt'
require 'core/tictactoe'
require 'uis/gui/menu_window'
require 'uis/gui/main_window'

module UIs
  module Gui
    class Runner
      attr_accessor :menu
      attr_accessor :games

      def initialize()
        @app = Qt::Application.new(ARGV)
        @games = []
        @menu = UIs::Gui::MenuWindow.new(lambda{|options|
          ttt = Core::TicTacToe.new
          ttt.set_board_size(options[:board])
          ttt.set_player_x(options[:x])
          ttt.set_player_o(options[:o])
          game = UIs::Gui::MainWindow.new(ttt, options[:board])
          @games.push(game)
          game.show
        })
      end

      def run
        @menu.show
        @app.exec
      end
    end
  end
end

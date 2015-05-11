require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/menu_window'
require 'tictactoe/gui/main_window'

module Tictactoe
  module Gui
    class Runner
      attr_reader :menu, :games

      def initialize()
        @running = false
        @app = Qt::Application.new(ARGV)
        @games = []
        @menu = MenuWindow.new(lambda{|options|
          ttt = Game.new
          ttt.set_board_size(options[:board])
          ttt.set_player_x(options[:x])
          ttt.set_player_o(options[:o])
          game = MainWindow.new(ttt, options[:board])
          @games.push(game)
          game.show if @running
        })
      end

      def run
        @running = true
        @menu.show
        @games.each do |game|
          game.show
        end
        @app.exec
      end
    end
  end
end

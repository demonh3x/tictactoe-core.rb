require 'Qt'
require 'uis/gui/main_window'
require 'core/tictactoe'

module UIs
  module Gui
    class Runner
      attr_accessor :gui

      def initialize()
        @gui = UIs::Gui::MainWindow.new(Core::TicTacToe.new)
      end

      def run
        gui.run
      end
    end
  end
end

require 'Qt'
require 'core/tictactoe'

module UIs
  module Gui
    class Runner
      def run
        ttt = Core::TicTacToe.new
        ttt.set_board_size(3)
        ttt.set_player_x(:human)
        ttt.set_player_o(:human)
        UIs::Gui::MainWindow.new(ttt).run
      end
    end

    class MainWindow < Qt::Widget
      def initialize(tictactoe)
        @ttt = tictactoe

        @app = Qt::Application.new(ARGV)
        super(nil)

        @side_size = 3
        @dimensions = 2

        setup_window
        setup_cells
        setup_board
        setup_result
      end
      
      def run
        self.show
        @app.exec
      end

      private
      def setup_window
        self.object_name = "main_window"
        self.resize(240, 220)

        @main_layout = Qt::GridLayout.new(self)
        @main_layout.objectName = "main_layout"
      end

      def setup_cells
        cell_count = @side_size ** @dimensions
        @cells = (0..cell_count-1).map {|move| UIs::Gui::Cell.new(self, move)}
      end

      def setup_board
        board_layout = Qt::GridLayout.new(self)
        board_layout.object_name = "board_layout"
        expanding_policy = Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)

        coordinates_sequence = (0..@side_size-1).to_a.repeated_permutation(@dimensions)
        @cells.each do |cell|
          coordinates = coordinates_sequence.next
          x = coordinates[0]
          y = coordinates[1]
          board_layout.add_widget(cell, x, y, 1, 1)
          cell.size_policy = expanding_policy
          Qt::Object.connect(cell, SIGNAL('clicked()'), self, SLOT("cell_clicked()"))
        end

        @main_layout.add_layout(board_layout, 0, 0, 1, 1)
      end
      
      def setup_result
        @result = Qt::Label.new(self)
        @result.object_name = "result"

        @main_layout.add_widget(@result, 1, 0, 1, 1)
      end

      slots :cell_clicked
      def cell_clicked
        @ttt.tick(sender.move)
        refresh_board
        refresh_result
      end

      def refresh_board
        marks = @ttt.marks

        @cells.each_with_index do |cell, index|
          mark = marks[index]
          cell.text = mark == nil ? index.to_s : mark.to_s
        end
      end

      def refresh_result
        winner = @ttt.winner

        if @ttt.is_finished?
          if winner == nil
            @result.text = "it is a draw"
          else
            @result.text = "#{winner.to_s} has won"
          end
        end
      end
    end

    class Cell < Qt::PushButton
      def initialize(parent, move)
        super(parent)
        @move = move

        i = move.to_s
        self.objectName = "cell_#{i}"
        self.text = i
      end

      attr_reader :move
    end
  end
end

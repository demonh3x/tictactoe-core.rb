require 'Qt'

module Tictactoe
  module Gui
    class MainWindow < Qt::Widget
      def initialize(tictactoe, side_size)
        @dimensions = 2
        @side_size = side_size

        @ttt = tictactoe

        @moves = Moves.new

        super(nil)

        setup_window
        setup_cells
        setup_board
        setup_result
        setup_timer
      end

      private
      def setup_window
        self.object_name = "main_window"
        self.resize(240, 220)

        @main_layout = Qt::GridLayout.new(self)
        @main_layout.object_name = "main_layout"
      end

      def setup_cells
        cell_count = @side_size ** @dimensions
        @cells = (0..cell_count-1).map {|move| Cell.new(self, move)}
      end

      def setup_board
        board_layout = Qt::GridLayout.new()
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

        @main_layout.add_layout(board_layout, 3, 0, 1, 1)
      end
      
      def setup_result
        @result = Qt::Label.new(self)
        @result.object_name = "result"

        @main_layout.add_widget(@result, 4, 0, 1, 1)
      end

      def setup_timer
        @timer = Qt::Timer.new(self)
        @timer.object_name = 'timer'
        Qt::Object.connect(@timer, SIGNAL('timeout()'), self, SLOT('tick()'))
        @timer.start
      end

      slots :tick
      def tick
        @ttt.tick(@moves)
        refresh_board
        refresh_result
      end

      slots :start
      def start
        @timer.start
      end

      slots :cell_clicked
      def cell_clicked
        make_move(sender.move)
        refresh_board
        refresh_result
      end

      def make_move(move)
        @moves.add(move)
        @ttt.tick(@moves)
      end

      def refresh_board
        marks = @ttt.marks

        @cells.each_with_index do |cell, index|
          mark = marks[index]
          cell.text = mark.to_s
        end
      end

      def refresh_result
        if @ttt.is_finished?
          winner = @ttt.winner

          if winner == nil
            @result.text = "It is a draw."
          else
            @result.text = "Player #{winner.to_s.upcase} has won."
          end
        end
      end
    end

    class Moves
      def initialize()
        @moves = []
      end

      def add(move)
        @moves.push(move)
      end

      def get_move!
        @moves.pop
      end
    end

    class Cell < Qt::PushButton
      def initialize(parent, move)
        super(parent)
        @move = move

        i = move.to_s
        self.objectName = "cell_#{i}"
      end

      attr_reader :move
    end
  end
end

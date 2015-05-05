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
        MainWindow.new(ttt).run
      end
    end

    class MainWindow < Qt::Widget
      def initialize(tictactoe)
        @ttt = tictactoe

        @app = Qt::Application.new(ARGV)
        super(nil)

        setup_window_attributes
        create_board
        create_result
      end
      
      def run
        self.show
        @app.exec
      end

      def move(loc)
        @ttt.tick(loc)
        refresh_board
        refresh_result
      end

      def refresh_board
        cells = [@cell_0, @cell_1, @cell_2, @cell_3, @cell_4, @cell_5, @cell_6, @cell_7, @cell_8]
        marks = @ttt.marks

        cells.each_with_index do |cell, index|
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

      slots :cell_0_clicked
      def cell_0_clicked()
        move(0)
      end
      
      slots :cell_1_clicked
      def cell_1_clicked()
        move(1)
      end
      
      slots :cell_2_clicked
      def cell_2_clicked()
        move(2)
      end
      
      slots :cell_3_clicked
      def cell_3_clicked()
        move(3)
      end
      
      slots :cell_4_clicked
      def cell_4_clicked()
        move(4)
      end
      
      slots :cell_5_clicked
      def cell_5_clicked()
        move(5)
      end
      
      slots :cell_6_clicked
      def cell_6_clicked()
        move(6)
      end
      
      slots :cell_7_clicked
      def cell_7_clicked()
        move(7)
      end
      
      slots :cell_8_clicked
      def cell_8_clicked()
        move(8)
      end
      
      private
      def setup_window_attributes
        self.object_name = "main_window"
        self.resize(238, 216)
      end

      def create_board
        @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::Preferred, Qt::SizePolicy::Preferred)
        @sizePolicy.setHorizontalStretch(0)
        @sizePolicy.setVerticalStretch(0)
        @sizePolicy.heightForWidth = self.sizePolicy.hasHeightForWidth
        @gridLayout = Qt::GridLayout.new(self)
        @gridLayout.objectName = "gridLayout"
        @boardLayout = Qt::GridLayout.new()
        @boardLayout.objectName = "boardLayout"


        @cell_0 = Qt::PushButton.new(self)
        @cell_0.objectName = "cell_0"
        @sizePolicy1 = Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)
        @sizePolicy1.setHorizontalStretch(0)
        @sizePolicy1.setVerticalStretch(0)
        #@sizePolicy1.heightForWidth = @cell_0.sizePolicy.hasHeightForWidth
        @cell_0.sizePolicy = @sizePolicy1
        @cell_0.text = Qt::Application.translate("Form", "0", nil, Qt::Application::UnicodeUTF8)
        @boardLayout.addWidget(@cell_0, 0, 0, 1, 1)

        @cell_1 = Qt::PushButton.new(self)
        @cell_1.objectName = "cell_1"
        #@sizePolicy1.heightForWidth = @cell_1.sizePolicy.hasHeightForWidth
        @cell_1.sizePolicy = @sizePolicy1
        @cell_1.text = Qt::Application.translate("Form", "1", nil, Qt::Application::UnicodeUTF8)
        @boardLayout.addWidget(@cell_1, 0, 1, 1, 1)

        @cell_2 = Qt::PushButton.new(self)
        @cell_2.objectName = "cell_2"
        #@sizePolicy1.heightForWidth = @cell_2.sizePolicy.hasHeightForWidth
        @cell_2.sizePolicy = @sizePolicy1
        @cell_2.text = Qt::Application.translate("Form", "2", nil, Qt::Application::UnicodeUTF8)
        @boardLayout.addWidget(@cell_2, 0, 2, 1, 1)

        @cell_3 = Qt::PushButton.new(self)
        @cell_3.objectName = "cell_3"
        @sizePolicy1.heightForWidth = @cell_3.sizePolicy.hasHeightForWidth
        @cell_3.sizePolicy = @sizePolicy1
        @cell_3.text = Qt::Application.translate("Form", "3", nil, Qt::Application::UnicodeUTF8)
        @boardLayout.addWidget(@cell_3, 1, 0, 1, 1)


        @cell_4 = Qt::PushButton.new(self)
        @cell_4.objectName = "cell_4"
        @sizePolicy1.heightForWidth = @cell_4.sizePolicy.hasHeightForWidth
        @cell_4.sizePolicy = @sizePolicy1
        @cell_4.text = Qt::Application.translate("Form", "4", nil, Qt::Application::UnicodeUTF8)
        @boardLayout.addWidget(@cell_4, 1, 1, 1, 1)


        @cell_5 = Qt::PushButton.new(self)
        @cell_5.objectName = "cell_5"
        @sizePolicy1.heightForWidth = @cell_5.sizePolicy.hasHeightForWidth
        @cell_5.sizePolicy = @sizePolicy1
        @cell_5.text = Qt::Application.translate("Form", "5", nil, Qt::Application::UnicodeUTF8)
        @boardLayout.addWidget(@cell_5, 1, 2, 1, 1)


        @cell_6 = Qt::PushButton.new(self)
        @cell_6.objectName = "cell_6"
        @sizePolicy1.heightForWidth = @cell_6.sizePolicy.hasHeightForWidth
        @cell_6.sizePolicy = @sizePolicy1
        @boardLayout.addWidget(@cell_6, 2, 0, 1, 1)
        @cell_6.text = Qt::Application.translate("Form", "6", nil, Qt::Application::UnicodeUTF8)


        @cell_7 = Qt::PushButton.new(self)
        @cell_7.objectName = "cell_7"
        @sizePolicy1.heightForWidth = @cell_7.sizePolicy.hasHeightForWidth
        @cell_7.sizePolicy = @sizePolicy1
        @boardLayout.addWidget(@cell_7, 2, 1, 1, 1)
        @cell_7.text = Qt::Application.translate("Form", "7", nil, Qt::Application::UnicodeUTF8)


        @cell_8 = Qt::PushButton.new(self)
        @cell_8.objectName = "cell_8"
        @sizePolicy1.heightForWidth = @cell_8.sizePolicy.hasHeightForWidth
        @cell_8.sizePolicy = @sizePolicy1
        @boardLayout.addWidget(@cell_8, 2, 2, 1, 1)
        @cell_8.text = Qt::Application.translate("Form", "8", nil, Qt::Application::UnicodeUTF8)

        
        @gridLayout.addLayout(@boardLayout, 0, 0, 1, 1)

        Qt::Object.connect(@cell_0, SIGNAL('clicked()'), self, SLOT('cell_0_clicked()'))
        Qt::Object.connect(@cell_1, SIGNAL('clicked()'), self, SLOT('cell_1_clicked()'))
        Qt::Object.connect(@cell_2, SIGNAL('clicked()'), self, SLOT('cell_2_clicked()'))
        Qt::Object.connect(@cell_3, SIGNAL('clicked()'), self, SLOT('cell_3_clicked()'))
        Qt::Object.connect(@cell_4, SIGNAL('clicked()'), self, SLOT('cell_4_clicked()'))
        Qt::Object.connect(@cell_5, SIGNAL('clicked()'), self, SLOT('cell_5_clicked()'))
        Qt::Object.connect(@cell_6, SIGNAL('clicked()'), self, SLOT('cell_6_clicked()'))
        Qt::Object.connect(@cell_7, SIGNAL('clicked()'), self, SLOT('cell_7_clicked()'))
        Qt::Object.connect(@cell_8, SIGNAL('clicked()'), self, SLOT('cell_8_clicked()'))

      end
      
      def create_result
        @result = Qt::Label.new(self)
        @result.object_name = "result"

        @gridLayout.addWidget(@result, 1, 0, 1, 1)
      end
    end
  end
end

module Tictactoe
  class Players
    class Player
      attr_reader :mark
      attr_accessor :next

      def initialize(mark)
        @mark = mark 
      end
    end

    attr_reader :first

    def initialize(x, o)
      first = Player.new(x)
      second = Player.new(o)
      first.next = second
      second.next = first

      @first = first
    end
  end
end

module Players
  module AI
    class RandomStrategyPlayer
      attr_reader :mark

      def initialize(mark, strategy, random)
        @mark = mark
        @strategy = strategy
        @random = random
      end

      def ask_for_location(state)
        select_random strategy.call(state)
      end

      def play(state)
        state.make_move(ask_for_location(state), mark)
      end

      private
      attr_accessor :random, :strategy

      def select_random(list)
        index = bounded_random list.size
        list[index]
      end

      def bounded_random(outer_bound)
        (random.rand * outer_bound).to_i
      end
    end
  end
end

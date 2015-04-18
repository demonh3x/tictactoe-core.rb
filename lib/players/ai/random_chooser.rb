module Players
  module AI
    class RandomChooser
      def initialize(random)
        @random = random
      end

      def choose_one(list)
        index = bounded_random list.size
        list[index]
      end

      private
      attr_accessor :random

      def bounded_random(outer_bound)
        (random.rand * outer_bound).to_i
      end
    end
  end
end

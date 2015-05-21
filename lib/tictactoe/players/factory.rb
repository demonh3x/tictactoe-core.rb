module Tictactoe
  module Players
    class Factory
      def initialize(computer_factory)
        @factories = {
          :computer => computer_factory
        }
      end

      def create(type, mark)
        factories[type].call(mark)
      end

      def register_human_factory(human_factory)
        factories[:human] = human_factory
      end

      private
      attr_accessor :factories
    end
  end
end

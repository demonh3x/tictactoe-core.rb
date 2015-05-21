module Tictactoe
  module Players
    class Factory
      def initialize()
        @factories = {}
      end

      def create(type, mark)
        raise "No factory has been defined for type: #{type}" unless factories.has_key?(type)
        factories[type].call(mark)
      end

      def register(type, factory)
        factories[type] = factory
      end

      private
      attr_accessor :factories
    end
  end
end

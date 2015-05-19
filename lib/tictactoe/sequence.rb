module Tictactoe
  class Sequence
    class Node
      attr_reader :value
      attr_accessor :next

      def initialize(value)
        @value = value 
      end
    end

    attr_reader :first

    def initialize(values)
      nodes = values.map{|value| Node.new(value)}
      nodes.each_with_index do |node, index|
        next_index = (index +1) % nodes.length
        node.next = nodes[next_index]
      end

      @first = nodes.first
    end
  end
end

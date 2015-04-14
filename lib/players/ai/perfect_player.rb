require 'players/ai/random_strategy_player'
require 'players/ai/ab_minimax'
require 'players/play_behaviour'

class PerfectPlayer < RandomStrategyPlayer
  module TTT
    class Leaf
      def initialize(state, me, transition = nil)
        @state = state
        @me = me
        @transition = transition
      end

      def childs
        NO_CHILDS
      end

      def score
        @score ||= winner_score(state, me) || (raise "Not finished!")
        @score
      end

      def transition
        @transition || (raise "No transition!")
      end

      NO_CHILDS = []
      attr_reader :state, :me

      def winner_score(state, me)
        state.when_finished do |winner|
          case winner
          when me
            1
          when nil
            0
          else
            -1
          end
        end
      end
    end

    class Tree
      def initialize(state, me, opponent, current_player, transition = nil)
        @state = state
        @me = me
        @opponent = opponent
        @current_player = current_player
        @transition = transition
      end

      def childs
        c = state.available_moves.lazy.map do |transition|
          next_state = state.make_move transition, current_player
          next_state.when_finished do |w|
            Leaf.new(next_state, me, transition)
          end || Tree.new(next_state, me, opponent, current_player == me ? opponent : me, transition)
        end

        def c.empty?
          false
        end

        c
      end

      def transition
        @transition || (raise "No transition!")
      end

      attr_reader :state, :me, :opponent, :current_player
    end

    class NodeFactory
      def initialize(me, opponent)
        @me = me
        @opponent = opponent
      end

      def create(state)
        state.when_finished do |w|
          Leaf.new(state, me)
        end || Tree.new(state, me, opponent, me)
      end

      private
      attr_reader :me, :opponent
    end
  end

  include PlayBehaviour

  def initialize(my_mark, opponents_mark, random)
    node_factory = TTT::NodeFactory.new(my_mark, opponents_mark)
    minimax = ABMinimax.new(-1, 0, 5)

    strategy = lambda do |state|
      minimax.evaluate(node_factory.create state).map(&:transition)
    end

    super(my_mark, strategy, random)
  end
end

require 'players/ai/ab_minimax'

module Players
  module AI
    class PerfectPlayer
      MAXIMUM_SCORE = 2
      MINIMUM_SCORE = -2
      NEUTRAL_SCORE = 0
      SCORE_FOR_UNKNOWN_FUTURE = -1

      module TTT
        class Node
          def initialize(state, me, opponent, current_player)
            @state = state
            @me = me
            @opponent = opponent
            @current_player = current_player
          end
          attr_reader :state, :me, :opponent, :current_player

          def is_leaf?
            state.when_finished{true} || false
          end

          def childs
            state.available_moves.lazy.map do |transition|
              next_player = current_player == me ? opponent : me
              next_state = state.make_move transition, current_player
              Node.new(next_state, me, opponent, next_player)
            end
          end

          def score
            state.when_finished do |winner|
              case winner
              when me
                MAXIMUM_SCORE
              when nil
                NEUTRAL_SCORE
              else
                MINIMUM_SCORE
              end
            end
          end
        end
      end

      def initialize(mark, opponents_mark, chooser)
        @mark = mark
        @opponents_mark = opponents_mark
        @chooser = chooser
      end

      attr_accessor :mark, :opponents_mark

      def play(state)
        @chooser.choose_one(find_best_locations state)
      end

      def find_best_locations(state)
        depth = dynamic_depth_for state

        ab_minimax = Players::AI::ABMinimax.new(MINIMUM_SCORE, SCORE_FOR_UNKNOWN_FUTURE, depth)

        locs = ab_minimax.evaluate(TTT::Node.new(state, mark, opponents_mark, mark)).map(&:state)

        locs
      end

      def dynamic_depth_for(state)
        played_moves = state.board.locations.length - state.available_moves.length

        if state.board.locations.length == 16
          depth = [7, played_moves].min
        else
          played_moves += 4
          depth = [5, played_moves].min
        end

        depth
      end
    end
  end
end

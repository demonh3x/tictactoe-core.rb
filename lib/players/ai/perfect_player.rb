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
          def initialize(state, me, opponent, current_player, transition = nil)
            @state = state
            @me = me
            @opponent = opponent
            @current_player = current_player
            @transition = transition
          end
          attr_reader :state, :me, :transition, :opponent, :current_player

          def is_final?(state)
            state.when_finished{true} || false
          end

          def childs
            return [] if is_final?(state)

            c = state.available_moves.lazy.map do |transition|
              next_player = current_player == me ? opponent : me
              next_state = state.make_move transition, current_player
              Node.new(next_state, me, opponent, next_player, transition)
            end

            def c.empty?
              false
            end

            c
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

      def initialize(my_mark, opponents_mark)
        @strategy = lambda do |state|
          played_moves = state.board.locations.length - state.available_moves.length
          if state.board.locations.length == 16
            depth = [7, played_moves].min
          else
            played_moves += 4
            depth = [5, played_moves].min
          end

          ab_minimax = Players::AI::ABMinimax.new(MINIMUM_SCORE, SCORE_FOR_UNKNOWN_FUTURE, depth)

          locs = ab_minimax.evaluate(TTT::Node.new(state, my_mark, opponents_mark, my_mark)).map(&:transition)

          locs
        end
      end

      def call(state)
        @strategy.call(state)
      end
    end
  end
end

require 'core/state'
require 'boards/board_type_factory'
require 'players/ai/perfect_player'
require 'players/ai/random_chooser'

module Core
  class TicTacToe
    def initialize()
      @players = [:x, :o].cycle
      @types = {}
      chooser = Players::AI::RandomChooser.new(Random.new)
      @ais = {
        :x => Players::AI::PerfectPlayer.new(:x, :o, chooser),
        :o => Players::AI::PerfectPlayer.new(:o, :x, chooser)
      }
    end

    def set_board_size(size)
      @size = size
      @board = Boards::BoardTypeFactory.new.create(size)
      @state = State.new(@board)
    end

    def set_player_x(type)
      @types[:x] = type
    end

    def set_player_o(type)
      @types[:o] = type
    end

    def tick(player)
      move = get_move(player)

      if move != nil
        @state = @state.make_move(move, current_mark)
        @players.next
      end
    end

    def is_finished?
      @state.when_finished{true} || false
    end

    def winner
      @state.when_finished{|winner| winner}
    end

    def marks
      @state.layout.map{|loc, mark| mark}
    end

    def available
      @state.available_moves
    end

    private
    def current_mark
      @players.peek
    end

    def is_human_turn?
      type = @types[current_mark]
      type == :human
    end

    def get_move(player)
      if is_human_turn?
        get_human_move(player)
      else
        get_computer_move
      end
    end

    def get_human_move(player)
      player.move
    end

    def get_computer_move
      ai = @ais[current_mark]
      ai.update(@state)
      ai.play_location
    end
  end
end

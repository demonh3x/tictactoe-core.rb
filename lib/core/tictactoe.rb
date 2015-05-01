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
      @ai_moves = [8, 7, 6, 5]
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
      @state = @state.make_move(move[:move], move[:mark]) if move != nil
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

    private
    def get_move(player)
      mark = @players.peek
      type = @types[mark]

      case type
      when :human
        move = player.move
        return nil if move == nil
        @players.next
        {:mark => mark, :move => player.move}
      when :computer
        @players.next
        ai = @ais[mark]
        ai.update(@state)
        move = ai.play_location
        {:mark => mark, :move => move}
      end
    end
  end
end

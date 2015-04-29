module Core
  class Game
    def initialize(state, ui, players)
      @state = state
      @ui = ui
      @players = players
      @turns = players.cycle
      advance_player
    end

    def finished?
      state.when_finished{true} || false
    end

    def start
      update
    end

    def step
      if current_player.is_ready_to_move?
        self.state = current_player.play
        update
        advance_player
      end
    end

    private

    attr_accessor :state, :ui, :players, :turns, :current_player

    def advance_player
      self.current_player = turns.next
    end

    def update
      ui.update(state)
      players.each do |player|
        player.update(state)
      end
    end
  end
end

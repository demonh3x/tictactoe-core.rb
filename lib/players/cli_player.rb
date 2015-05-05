require 'uis/cli/move_reader'

module Players
  class CliPlayer
    def initialize(mark, input, output)
      @input = input
      @output = output
      @mark = mark
    end

    def is_ready_to_move?
      true
    end

    def update(state)
      self.state = state
    end

    def play
      state.make_move(read_valid_location(state), mark)
    end

    attr_reader :mark

    private

    attr_reader :input, :output
    attr_accessor :state

    def read_valid_location(state)
      UIs::Cli::MoveReader.new(input, output, StateAdapter.new(state)).get_move!
    end
  end

  class StateAdapter
    def initialize(state)
      @state = state
    end

    def available
      @state.available_moves
    end
  end
end

module Players
  module PlayBehaviour
    def play(state)
      state.make_move(ask_for_location(state), mark)
    end
  end
end

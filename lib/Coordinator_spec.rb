require 'Coordinator'

RSpec.describe "Coordinator" do
  class GameDouble
    def initialize(messages)
      @messages = messages
      @state_responses = []
      @make_move_calls = []
      @is_finished_responses = []
      @winner_responses = []
    end

    def state
      @messages << {:obj => self, :method => :state}
      @state_responses.shift
    end

    def add_state_response(state)
      @state_responses.push(state)
    end

    def is_finished?
      @is_finished_responses.shift
    end

    def add_finished_response(is_finished)
      @is_finished_responses << is_finished
    end

    def winner
      @winner_responses.shift
    end

    def add_winner_response(winner)
      @winner_responses << winner
    end

    def make_move(player, location)
      @messages << {:obj => self, :method => :make_move}
      @make_move_calls << {:player => player, :location => location}
    end

    def make_move_calls
      @make_move_calls.clone
    end
  end

  class UiDouble
    def initialize(messages)
      @messages = messages
      @update_calls = []
      @location_responses = []
      @announce_result_calls = []
    end

    def update(state)
      @messages << {:obj => self, :method => :update}
      @update_calls << {:state => state}
    end

    def update_calls
      @update_calls.clone
    end

    def ask_for_location
      @messages << {:obj => self, :method => :ask_for_location}
      @location_responses.pop
    end

    def add_location_response(location)
      @location_responses << location
    end

    def announce_result(winner)
      @announce_result_calls << {:winner => winner}
    end

    def announce_result_calls
      @announce_result_calls.clone
    end
  end

  def stub_state(state)
    @game.add_state_response(state)
  end

  def stub_ui_move(ui, location)
    ui.add_location_response(location)
  end

  def expect_uis_received_state(index, state)
    [@x_ui, @o_ui].each do |ui|
      update_call = ui.update_calls[index]
      expect(update_call[:state]).to equal(state)
    end
  end

  def expect_maked_move(index, player, location)
    maked_move = @game.make_move_calls[index]
    expect(maked_move[:player]).to equal(player)
    expect(maked_move[:location]).to equal(location)
  end

  before(:each) do
    @messages = []

    @game = GameDouble.new(@messages)

    @x_ui = UiDouble.new(@messages)
    @o_ui = UiDouble.new(@messages)

    @x_player = "::x_player::"
    @o_player = "::o_player::"

    players = [
      {:player => @x_player, :ui => @x_ui},
      {:player => @o_player, :ui => @o_ui},
    ]

    @coordinator = Coordinator.new(@game, players) 
  end

  describe "given the game is finished" do
    before(:each) do
      @game.add_finished_response(true)
    end
    
    it "should be finished" do
      expect(@coordinator.finished?).to eq(true)
    end

    it "when doing a step should raise error" do
      expect{@coordinator.step}.to raise_error("The game is finished!")
    end
  end
  
  describe "given the game is not finished" do
    before(:each) do
      @game.add_finished_response(false)
    end

    it "should not be finished" do
      expect(@coordinator.finished?).to eq(false)
    end

    describe "and the next step finishes the game" do
      before(:each) do
        @game.add_finished_response(true)

        @winner = "::winner::"
        @game.add_winner_response(@winner)

        @coordinator.step
      end

      it "should announce the result of the game" do
        expect(@x_ui.announce_result_calls.last[:winner]).to equal(@winner)
        expect(@o_ui.announce_result_calls.last[:winner]).to equal(@winner)
      end
    end

    describe "after the first step" do
      before(:each) do
        @initial_game_state = "::initial_game_state::"
        stub_state(@initial_game_state)

        @first_x_location = "::first_x_location::"
        stub_ui_move(@x_ui, @first_x_location)

        @second_game_state = "::second_game_state::"
        stub_state(@second_game_state)

        @coordinator.step
      end

      it "should update all the UIs with the initial game state" do
        expect_uis_received_state(0, @initial_game_state)
      end

      it "should ask the first player for a location and send it to game" do
        expect_maked_move(0, @x_player, @first_x_location)
      end

      it "should update all the UIs with the second game state" do
        expect_uis_received_state(1, @second_game_state)
      end

      it "should have sent the messages in order" do
        expected_messages = [
          {:obj => @game, :method => :state},
          {:obj => @x_ui, :method => :update},
          {:obj => @o_ui, :method => :update},
          {:obj => @x_ui, :method => :ask_for_location},
          {:obj => @game, :method => :make_move},
          {:obj => @game, :method => :state},
          {:obj => @x_ui, :method => :update},
          {:obj => @o_ui, :method => :update},
        ]
        expect(@messages).to eq(expected_messages)
      end

      describe "subsequent steps" do
        before(:each) do
          @messages.clear
          @coordinator.step
        end

        it "should only do one update to the UIs" do
          expected_messages = [
            {:obj => @o_ui, :method => :ask_for_location},
            {:obj => @game, :method => :make_move},
            {:obj => @game, :method => :state},
            {:obj => @x_ui, :method => :update},
            {:obj => @o_ui, :method => :update},
          ]
          expect(@messages).to eq(expected_messages)
        end
      end
    end
  end
end

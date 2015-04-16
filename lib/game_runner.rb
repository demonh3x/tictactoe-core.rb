require 'core/game'
require 'uis/cli'
require 'core/state'

require 'options/cli_asker'
require 'options/option'

require 'options/play_again_option'

require 'options/board_type_selection'
require 'boards/board_type_factory'

require 'options/players_selection'
require 'players/players_factory'

class GameRunner
  def initialize(input=$stdin, output=$stdout, random=Random.new)
    @output = output

    cli = Options::CliAsker.new(input, output)
    @board_type = create_board_option cli
    @play_again = create_play_again_option cli
    @who_will_play = create_players_option cli, input, output, random
  end

  def run
    begin 
      game = create_game
      game.start
      game.step until game.finished?
    end while play_again.get
  end

  private
  attr_accessor :output, :play_again, :board_type, :who_will_play

  def create_board_option(cli)
    board_selection = Options::BoardTypeSelection.new(cli)
    board_factory = Boards::BoardTypeFactory.new
    Options::Option.new(board_selection, board_factory)
  end

  def create_play_again_option(cli)
    Options::PlayAgainOption.new(cli)
  end

  def create_players_option(cli, input, output, random)
    players_selection = Options::PlayersSelection.new(cli)
    players_factory = Players::PlayersFactory.new(input, output, random)
    Options::Option.new(players_selection, players_factory)
  end

  def create_game
    board = board_type.get
    players = who_will_play.get
    Core::Game.new(
      Core::State.new(board),
      UIs::Cli.new(output),
      players
    )
  end
end

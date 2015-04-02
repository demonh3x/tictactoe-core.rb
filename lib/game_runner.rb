require 'core/game'
require 'uis/cli'
require 'core/state'

require 'options/cli_options'
require 'options/option'

require 'options/play_again_option'

require 'options/board_type_selection'
require 'options/board_type_factory'

require 'options/players_selection'
require 'options/players_factory'

class GameRunner
  def initialize(input=$stdin, output=$stdout, random=Random.new)
    @output = output

    cli = CliOptions.new(input, output)
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
    board_selection = BoardTypeSelection.new(cli)
    board_factory = BoardTypeFactory.new
    Option.new(board_selection, board_factory)
  end

  def create_play_again_option(cli)
    PlayAgainOption.new(cli)
  end

  def create_players_option(cli, input, output, random)
    players_selection = PlayersSelection.new(cli)
    players_factory = PlayersFactory.new(input, output, random)
    Option.new(players_selection, players_factory)
  end

  def create_game
    board = board_type.get
    players = who_will_play.get
    Game.new(
      State.new(board),
      Cli.new(output),
      players
    )
  end
end

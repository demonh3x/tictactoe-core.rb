require 'core/game'
require 'uis/cli'
require 'core/state'
require 'options/play_again_option'
require 'board_type_option'
require 'players_option'

class Main
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
    BoardTypeOption.new(board_selection, board_factory)
  end

  def create_play_again_option(cli)
    PlayAgainOption.new(cli)
  end

  def create_players_option(cli, i, o, random)
    players_selection = PlayersSelection.new(cli)
    players_factory = PlayersFactory.new(i, o, random)
    PlayersOption.new(players_selection, players_factory)
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

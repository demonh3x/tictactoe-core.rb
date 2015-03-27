require 'game'
require 'cli'
require 'state'
require 'play_again_option'
require 'board_type_option'
require 'players_option'

class Main
  def initialize(input=$stdin, output=$stdout)
    @output = output

    @board_type = create_board_option(input, output)

    @play_again = PlayAgainOption.new(input, output)
    @who_will_play = PlayersOption.new(input, output)
  end

  def run
    begin 
      game = create_game
      game.start
      game.step until game.finished?
    end while play_again.ask
  end

  private
  attr_accessor :output, :play_again, :board_type, :who_will_play

  def create_board_option(input, output)
    cli_asker = CliOptions.new(input, output)
    board_selection = BoardTypeSelection.new(cli_asker)
    board_factory = BoardTypeFactory.new
    @board_type = BoardTypeOption.new(board_selection, board_factory)
  end

  def create_game
    board = board_type.get
    players = who_will_play.ask
    Game.new(
      State.new(board),
      Cli.new(output),
      players
    )
  end
end

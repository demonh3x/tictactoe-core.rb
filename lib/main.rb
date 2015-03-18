require 'coordinator'
require 'cli'
require 'random_player'
require 'game'
require 'state'
require 'three_by_three_board'
require 'play_again_option'
require 'board_type_option'
require 'players_option'

class Main
  def initialize(input=$stdin, output=$stdout, random=Random.new)
    @output = output
    @play_again = PlayAgainOption.new(input, output)
    @board_type = BoardTypeOption.new(input, output)
    @who_will_play = PlayersOption.new(input, output, random)
  end

  def run
    begin 
      engine = create_game_engine ask_for_board_type, ask_for_players
      engine.step until engine.finished?
    end while play_again?
  end

  private
  attr_accessor :output, :play_again, :board_type, :who_will_play

  def play_again?
    play_again.ask
  end

  def ask_for_board_type
    board_type.ask
  end

  def ask_for_players
    who_will_play.ask
  end

  def uis
    [Cli.new({:x => 'X', :o => 'O'}, output)]
  end

  def create_game_engine(board, players)
    Coordinator.new(
      Game.new(State.new(board)), 
      uis,
      players
    )
  end
end

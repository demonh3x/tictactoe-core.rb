require 'Location'

class Cli
  def initialize(input, output, player_icons, board, player)
    @input = input
    @output = output
    @player_icons = player_icons
    @board = board
    @player = player
  end

  def update(state)
    @output.puts("  x 0   1   2")
    @output.puts("y +---+---+---+")
    (0..2).each do |y|
      @output.puts(
        "#{y} | #{get_icon(state, 0, y)} | #{get_icon(state, 1, y)} | #{get_icon(state, 2, y)} |\n" +
        "  +---+---+---+"
      )
    end
  end

  def ask_for_location
    print_turn
    read_valid_location
  end

  def announce_result(winner)
    if winner.nil?
      print_draw
    elsif winner == @player
      print_win
    else
      print_lose
    end
  end

  private

  def get_icon(state, x, y)
    player = state[loc(x, y)]
    icon = @player_icons[player]
    icon == nil ? ' ' : icon
  end

  def loc(x, y)
    Location.new(x, y)
  end

  def print_turn
    @output.puts "Your turn! Where do you want to play? (format: x,y)"
  end
  
  def read_valid_location
    begin
      location = read_location
      location_outside_board = !@board.locations.include?(location)
      print_location_outside_board if location_outside_board
    end while location_outside_board

    location
  end

  def read_location
    begin
      input_string = read_input
      location = parse_location(input_string)
      invalid_input = location.nil?
      print_invalid_input(input_string) if invalid_input
    end while invalid_input

    location
  end

  def read_input
      str = @input.gets
      raise "No data readed from the CLI input!" if str.nil?
      str.strip
  end

  def parse_location(location_string)
    parts = location_string.split(',').map{|s| Integer(s.strip) rescue nil}
    return nil if parts.any?{|p| p.nil?} || parts.size != 2
    x = parts[0]
    y = parts[1]
    loc(x, y)
  end

  def print_invalid_input(input_string)
    @output.puts "Don't understand \"#{input_string}\". Please, make sure you use the format \"x,y\""
  end
  
  def print_location_outside_board
    @output.puts "That location is outside the board. Please, try one inside it."
  end

  def print_draw
    @output.puts "It is a draw."
  end

  def print_win
    @output.puts "You win!"
  end

  def print_lose
    @output.puts "You lose."
  end
end

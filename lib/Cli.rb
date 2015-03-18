class Cli
  def initialize(player_icons, output)
    @output = output
    @player_icons = player_icons
  end

  def update(state)
    output.puts("  x 0   1   2")
    output.puts("y +---+---+---+")
    (0..2).each do |y|
      output.puts(
        "#{y} | #{get_icon(state, loc(0, y))} | #{get_icon(state, loc(1, y))} | #{get_icon(state, loc(2, y))} |\n" +
        "  +---+---+---+"
      )
    end
  end

  def announce_result(winner)
    if winner.nil?
      print_draw
    else
      print_winner(winner)
    end
  end

  private

  attr_reader :output, :player_icons

  def get_icon(state, loc)
    player = state.look_at(loc)
    icon = player_icons[player]
    icon == nil ? ' ' : icon
  end

  def loc(x, y)
    (y*3)+x
  end

  def print_draw
    output.puts "It is a draw."
  end

  def print_winner(winner)
    icon = player_icons[winner]
    output.puts "#{icon} has won!"
  end
end

class CliPlayer
  def initialize(mark, input, output)
    @input = input
    @output = output
    @mark = mark
  end

  def ask_for_location(state)
    print_turn
    read_valid_location(state)
  end

  attr_reader :mark

  private
  
  attr_reader :input, :output

  def print_turn
    output.puts "Your turn! Where do you want to play? (format: x,y)"
  end
  
  def read_valid_location(state)
    board = state.board
    begin
      location = read_location
      location_outside_board = !board.locations.include?(location)
      print_location_outside_board if location_outside_board
      location_already_occupied = !state.look_at(location).nil? 
      print_location_already_occupied if location_already_occupied
    end while location_outside_board || location_already_occupied

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
      str = input.gets
      raise "No data readed from the CLI input!" if str.nil?
      str.strip
  end

  def parse_location(location_string)
    parts = location_string.split(',').map{|s| Integer(s.strip) rescue nil}
    return nil if parts.any?{|p| p.nil?} || parts.size != 2
    x = parts[0]
    y = parts[1]
    (y*3)+x
  end

  def print_invalid_input(input_string)
    output.puts "Don't understand \"#{input_string}\". Please, make sure you use the format \"x,y\""
  end
  
  def print_location_outside_board
    output.puts "That location is outside the board. Please, try one inside it."
  end

  def print_location_already_occupied
    output.puts "That location is already occupied. Please, try an empty one."
  end
end

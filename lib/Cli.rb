class Cli
  def initialize(output)
    @output = output
  end

  def update(state)
    print_board state
  end

  def announce_result(winner)
    if winner.nil?
      print_draw
    else
      print_winner(winner)
    end
  end

  private

  attr_reader :output

  def print_board(state)
    marks_in_the_board = (0..8).map{|l| get_mark state, l}
    m = marks_in_the_board

    board =
    "  x 0   1   2\n" +
    "y +---+---+---+\n" +
    "0 | #{m[0]} | #{m[1]} | #{m[2]} |\n" +
    "  +---+---+---+\n" +
    "1 | #{m[3]} | #{m[4]} | #{m[5]} |\n" +
    "  +---+---+---+\n" +
    "2 | #{m[6]} | #{m[7]} | #{m[8]} |\n" +
    "  +---+---+---+"

    output.puts(board)
  end

  def get_mark(state, loc)
    mark = state.look_at(loc)
    mark == nil ? ' ' : mark.to_s
  end

  def loc(x, y)
    (y*3)+x
  end

  def print_draw
    output.puts "It is a draw."
  end

  def print_winner(winner)
    output.puts "#{winner.to_s} has won!"
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
    begin
      location = read_location
      available = available? state, location 
      print_not_available if !available
    end until available

    location
  end

  def available?(state, location)
    state.available_locations.include? location
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
    str.chomp
  end

  def parse_location(location_string)
    parts = location_string.split(',').map{|s| Integer(s.strip) rescue nil}
    return nil if parts.any?{|p| p.nil?} || parts.size != 2

    x = parts[0]
    y = parts[1]
    loc(x, y)
  end

  def loc(x, y)
    (y*3)+x
  end

  def print_invalid_input(input_string)
    output.puts "Don't understand \"#{input_string}\". Please, make sure you use the format \"x,y\""
  end
  
  def print_not_available
    output.puts "That location is not available. Please, try another one.\n"
  end
end

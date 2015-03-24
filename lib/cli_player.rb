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

module Core
  class State
    def self.new(board)
      optimized_class = Class.new(BaseState) do
        def self.get_code_for_winner_in(line)
          code = "(marks[#{line.first}] != nil) && "
          line.drop(1).each do |location|
            code += "(marks[#{line.first}] == marks[#{location}]) && "
          end
          code += "marks[#{line.first}]"
          code
        end

        def self.get_winner_code(board)
          board.lines
            .map{|line| "(#{get_code_for_winner_in line})"}
            .join(" || ")
        end

        class_eval(%Q{
          def winner
            @winner ||= (#{get_winner_code board}) || nil
          end
        })

        def self.get_is_full_code(board)
          board.locations
            .map{|location| "(marks[#{location}] != nil)"}
            .join(" && ")
        end

        class_eval(%Q{
          def is_full?
            @is_full ||= #{get_is_full_code board}
          end
        })

        def self.get_available_moves_code(board)
          board.locations
            .map{|location| "moves << #{location} if marks[#{location}] == nil"}
            .join("\n")
        end

        class_eval(%Q{
          def available_moves
            @available_moves ||= _available_moves
          end

          def _available_moves
            moves = []
            #{get_available_moves_code(board)}
            moves
          end
        })
      end

      optimized_class.new(board)
    end
  end

  private
  class BaseState
    def initialize(board, marks=[])
      @board = board
      @marks = marks
    end

    def available_moves
      #this method is optimized dynamically by State.new(board)
    end

    def make_move(location, mark)
      new_marks = marks.clone
      new_marks[location] = mark
      self.class.new(board, new_marks)
    end

    def when_finished(&block)
      yield winner if is_finished?
    end

    def layout
      board.locations.map do |location| 
        [location, marks[location]]
      end
    end

    def ==(other)
      return false if other.class <= self.class
      self.marks == other.marks
    end

    attr_reader :board

    protected
    attr_reader :marks

    private

    def is_finished?
      is_full? || has_winner?
    end

    def is_full?
      #this method is optimized dynamically by State.new(board)
    end

    def has_winner?
      winner != nil
    end

    def winner
      #this method is optimized dynamically by State.new(board)
    end
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

  def initialize
    @data = {}
    (1..9).each { |position| @data[position] = Cell.new(" ") }
  end

  def draw
    system 'clear'
    puts "  1  |  2  |  3  "
    puts "     |     |     "
    puts "  #{@data[1]}  |  #{@data[2]}  |  #{@data[3]}  "
    puts "-----+-----+-----"
    puts "  4  |  5  |  6  "
    puts "     |     |     "
    puts "  #{@data[4]}  |  #{@data[5]}  |  #{@data[6]}  "
    puts "-----+-----+-----"
    puts "  7  |  8  |  9  "
    puts "     |     |     "
    puts "  #{@data[7]}  |  #{@data[8]}  |  #{@data[9]}  "
  end

  def empty_cells
    @data.select {|_, cell| cell.empty?}.values
  end
 
  def empty_positions
    @data.select {|_, cell| cell.empty?}.keys
  end

  def board_full?
    empty_cells.size == 0
  end

  def mark_cell(selection, marker)
    @data[selection].mark(marker)
  end

  def three_in_a_row?(marker)
    WINNING_LINES.each do |line|
      return true if @data[line[0]].value == marker && @data[line[1]].value  == marker && @data[line[2]].value == marker
    end
    false
  end
end

class Cell
  attr_reader :value
  def initialize(value)
    @value = value
  end

  def empty?
    @value == " "
  end

  def mark(marker)
    @value = marker
  end

  def to_s
    @value
  end
end

class Player
  attr_reader :name, :marker
  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  def initialize
    @board = Board.new
    @human = Player.new("You", "X")
    @computer = Player.new("Computer", "O")
    @current_player = @human
  end

  def current_player_marks_cell
    if @current_player == @human
      begin
        puts "Please choose a position to mark (1-9)."
        selection = gets.chomp.to_i
      end until @board.empty_positions.include?(selection)
    else
      selection = @board.empty_positions.sample
    end
    @board.mark_cell(selection, @current_player.marker)
  end

  def alternate_player_turn
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def current_player_wins?
    @board.three_in_a_row?(@current_player.marker)
  end

  def play
    @board.draw
    loop do
      current_player_marks_cell
      @board.draw
      if current_player_wins?
        puts "#{@current_player.name} won!"
        break
      elsif @board.board_full?
        puts "It's a tie"
        break
      else
        alternate_player_turn
      end
    end
    puts "Play again sometime!"
  end
end

Game.new.play

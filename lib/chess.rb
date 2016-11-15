# chess.rb

class Chess
	attr_accessor :window, :board, :player, :input, :x, :y, :moving, :has_selected
	attr_reader :selected_xy
	def initialize()
		@player = :white
		@x = @y = 3
		@moving = false
		@has_selected = false
		@selected_xy = [nil,nil]
	end
	def start
		@window.show
	end
	def stop
		puts "[!] game stopped via Escape key"
		exit
	end
	def end_turn
		@player == :white ? @player = :black : @player = :white
	end
	def up
		@y -= 1 unless @y - 1 < 0 unless @moving
		@moving = true unless @y - 1 < 0
	end
	def down
		@y += 1 unless @y + 1 > 7 unless @moving
		@moving = true unless @y + 1 > 7
	end
	def left
		@x -= 1 unless @x - 1 < 0 unless @moving
		@moving = true unless @x - 1 < 0
	end
	def right
		@x += 1 unless @x + 1 > 7 unless @moving
		@moving = true unless @x + 1 > 7
	end
	def get_piece(_x, _y)
		$game.board.grid[_y][_x]
	end
	def find_xy(piece_obj)
		$game.board.grid.each do |y, row|
			row.each_key do |x|
				return [x, y] if $game.board.grid[y][x] == piece_obj
			end
		end
		#raise "COULD NOT FIND XY COORDINATES FOR #{piece_obj}"
	end
	def move_piece(_x, _y) #assumes there's a piece selected
		return nil if @selected_xy.nil? || @selected_xy.empty?
		#raise "ERROR: tried to move out of bounds (from #{@selected_xy[0]},#{@selected_xy[1]}) (vector #{_x},#{_y})" if @selected_xy[0] + _x > 7 || @selected_xy[0] + _x < 0 || @selected_xy[1] + _y > 7 || @selected_xy[1] + _y < 0
		unless [_x, _y] == $game.selected_xy || !$game.board.grid[_y][_x].nil?
			$game.board.grid[_y][_x] = $game.get_piece @selected_xy[0], @selected_xy[1]
			$game.board.grid[@selected_xy[1]][@selected_xy[0]] = nil
			deselect
			end_turn
		end
	end
	def select_piece(_x, _y)
		unless @has_selected
			$game.board.grid.each do |y, row|
				row.each do |x, item|
					if _x == x && _y == y && !$game.board.grid[y][x].nil?
						if $game.board.grid[y][x].color == @player
							break if @has_selected # idk it works
							@selected_xy = [x, y]
							@has_selected = true
							puts "[!] selected piece [#{x},#{y}]"
							@moving = true
						end
					end
				end
			end
		end
	end
	def deselect
		if @has_selected
			puts "[!] deselected piece at [#{@selected_xy[0]},#{@selected_xy[1]}]"
			@selected_xy = [nil, nil]
			@has_selected = false
		end
	end
end

class Chess::Piece
	attr_accessor :type
	attr_reader :color
	def initialize(type, c)
		@type = type
		@status = :alive
		@selected = false
		@color = c
		case type
		when :pawn
			c == :black ? @img = Chess::TILESET[0] : @img = Chess::TILESET[6]
		when :rook
			c == :black ? @img = Chess::TILESET[1] : @img = Chess::TILESET[7]
		when :knight
			c == :black ? @img = Chess::TILESET[2] : @img = Chess::TILESET[8]
		when :bishop
			c == :black ? @img = Chess::TILESET[3] : @img = Chess::TILESET[9]
		when :king
			c == :black ? @img = Chess::TILESET[4] : @img = Chess::TILESET[10]
		when :queen
			c == :black ? @img = Chess::TILESET[5] : @img = Chess::TILESET[11]
		end
	end
	def draw
		#5 pixel offset (up)
		coord = $game.find_xy self
		@img.draw coord[0] * 32, (coord[1] * 32) - 5, 2
	end
	def hovered?
		x = $game.x
		y = $game.y
		return true if x == @x && y == @y
	end

	def dead?
		@status == :alive ? false : true
	end
	def kill
		@status = :dead
		# TODO remove from grid
	end

	def to_s #why does this not work
		"#{@color[0,1]}:#{@type}"
	end
end

class Chess::Board
	attr_reader :black, :white, :grid
	def initialize
		@piece_selected = false

		# grid is [y (0-7)][x (0-7)] => chesspiece class object
		@grid = {}
		8.times do |row|
			grid[row] = {}
			8.times do |collumn|
				grid[row][collumn] = nil
			end
		end

		@grid.each do |y, row|
			row.each_key do |x|
				if y == 1
					@grid[y][x] = Chess::Piece.new(:pawn, :black)
				elsif y == 6
					@grid[y][x] = Chess::Piece.new(:pawn, :white)

				elsif y == 0 || y == 7
					y == 7 ? c = :white : c = :black #define color in this iteration
					if x == 0 || x == 7
						@grid[y][x] = Chess::Piece.new(:rook, c)
					elsif x == 1 || x == 6
						@grid[y][x] = Chess::Piece.new(:knight, c)
					elsif x == 2 || x == 5
						@grid[y][x] = Chess::Piece.new(:bishop, c)
					elsif x == 3
						@grid[y][x] = Chess::Piece.new(:queen, c)
					elsif x == 4
						@grid[y][x] = Chess::Piece.new(:king, c)
					end
				end
			end
		end
	end

	def draw
		@grid.each do |y, row|
			row.each_key do |x|
				@grid[y][x].draw unless @grid[y][x].nil? || @grid[y][x].dead?
			end
		end
	end
end
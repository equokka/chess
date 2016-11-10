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

	def select_piece(x, y)
		unless @has_selected
			@selected_xy = [x, y]
			@has_selected = true
			puts "[!] selected piece [#{x},#{y}]"
		end
	end
	def deselect
		if @has_selected
			@selected_xy = [nil, nil]
			@has_selected = false
			puts "[!] deselected piece at [#{x},#{y}]"
		end
	end
end

class Chess::Piece
	attr_accessor :type
	attr_reader :x, :y
	def initialize(type, c, x, y)
		@type = type
		@status = :alive
		@selected = false
		@x=x
		@y=y

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
	def move(x,y)
		raise "ERROR: tried to move out of bounds (from #{@x},#{@y}) (vector #{x},#{y})" if @x + x > 7 || @x + x < 0 || @y + y > 7 || @y + y < 0
		@x += x
		@y += y
	end
	def draw
		#5 pixel offset (up)
		@img.draw @x * 32, (@y * 32) - 5, 2
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
		@x = @y = -1 #can't select it now can you hacker fucker
	end
end

class Chess::Board
	attr_reader :black, :white
	def initialize
		@piece_selected = false
		@black = @white = []
		8.times do |i|
			@black << Chess::Piece.new(:pawn, :black, i, 1)
			@white << Chess::Piece.new(:pawn, :white, i, 6)
		end
		#rooks
		@black << Chess::Piece.new(:rook, :black, 0,0)
		@black << Chess::Piece.new(:rook, :black, 7,0)
		@white << Chess::Piece.new(:rook, :white, 0,7)
		@white << Chess::Piece.new(:rook, :white, 7,7)
		#hors- i mean knights
		@black << Chess::Piece.new(:knight, :black, 1,0)
		@black << Chess::Piece.new(:knight, :black, 6,0)
		@white << Chess::Piece.new(:knight, :white, 1,7)
		@white << Chess::Piece.new(:knight, :white, 6,7)
		#BISHOPS
		@black << Chess::Piece.new(:bishop, :black, 2,0)
		@black << Chess::Piece.new(:bishop, :black, 5,0)
		@white << Chess::Piece.new(:bishop, :white, 2,7)
		@white << Chess::Piece.new(:bishop, :white, 5,7)
		#queen
		@black << Chess::Piece.new(:queen, :black, 3,0)
		@white << Chess::Piece.new(:queen, :white, 3,7)
		#king
		@black << Chess::Piece.new(:king, :black, 4,0)
		@white << Chess::Piece.new(:king, :white, 4,7)

	end
	def draw
		@black.each { |p| p.draw unless p.dead? }
		@white.each { |p| p.draw unless p.dead? }
	end
end
# piece.rb

class Chess::Piece
	attr_accessor :type, :pawn_double_step
	attr_reader :color
	def initialize(type, c)
		@type = type
		@status = :alive
		@selected = false
		@color = c
		@pawn_double_step = false
		case type
		when :pawn
			c == :black ? @img = Chess::TILESET[0] : @img = Chess::TILESET[6]
			@pawn_double_step = true
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
	def kill
		# TODO remove from grid
	end

	def to_s #why does this not work
		"#{@color[0,1]}:#{@type}"
	end
end
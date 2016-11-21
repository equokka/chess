# piece.rb

class Chess::Piece
	attr_accessor :type, :pawn_double_step, :rook_can_do_castling
	attr_reader :color
	def initialize(type, c)
		@type = type
		@status = :alive
		@selected = false
		@color = c
		@type == :pawn ? @pawn_double_step = true : @pawn_double_step = false
		@type == :rook ? @rook_can_do_castling = true : @rook_can_do_castling = false
		update_type
	end
	def update_type
		case @type
		when :pawn
			@color == :black ? @img = Chess::TILESET[0] : @img = Chess::TILESET[6]
		when :rook
			@color == :black ? @img = Chess::TILESET[1] : @img = Chess::TILESET[7]
		when :knight
			@color == :black ? @img = Chess::TILESET[2] : @img = Chess::TILESET[8]
		when :bishop
			@color == :black ? @img = Chess::TILESET[3] : @img = Chess::TILESET[9]
		when :king
			@color == :black ? @img = Chess::TILESET[4] : @img = Chess::TILESET[10]
		when :queen
			@color == :black ? @img = Chess::TILESET[5] : @img = Chess::TILESET[11]
		end
	end
	def draw
		update_type
		#5 pixel offset (up)
		coord = $game.find_xy self
		@img.draw coord[0] * 32 + Chess::DRAW_OFFSET[0], ((coord[1] * 32) - 5) + Chess::DRAW_OFFSET[1], 2
	end
	def hovered?
		x = $game.x
		y = $game.y
		return true if x == @x && y == @y
	end
	def to_s
		case @type
		when :pawn
			type = "(-" + @type.to_s + "-)" 
		when :rook
			type = "(-" + @type.to_s + "-)" 
		when :knight
			type = "(" + @type.to_s + ")" 
		when :bishop
			type = "(" + @type.to_s + ")" 
		when :king
			type = "(-" + @type.to_s + "-)" 
		when :queen
			type = "(-" + @type.to_s + ")" 
		end
		"#{@color[0,1].upcase}:#{type}"
	end
end
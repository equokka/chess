# chess.rb

class Chess
	attr_accessor :window, :board, :player
	def initialize()
		@player = :white
	end
	def start
		@window.show
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
		#gross
		case type
		when :pawn
			c == :black ? @img = Chess::CHESSPIECES[0] : @img = Chess::CHESSPIECES[6]
		when :rook
			c == :black ? @img = Chess::CHESSPIECES[1] : @img = Chess::CHESSPIECES[7]
		when :knight
			c == :black ? @img = Chess::CHESSPIECES[2] : @img = Chess::CHESSPIECES[8]
		when :bishop
			c == :black ? @img = Chess::CHESSPIECES[3] : @img = Chess::CHESSPIECES[9]
		when :king
			c == :black ? @img = Chess::CHESSPIECES[4] : @img = Chess::CHESSPIECES[10]
		when :queen
			c == :black ? @img = Chess::CHESSPIECES[5] : @img = Chess::CHESSPIECES[11]
		end
	end
	def move(x,y)

	end
	def draw
		#5 pixel offset (up)
		@img.draw @x * 32, (@y * 32) - 5, 1
	end
	def hovered?
		x = $game.window.x
		y = $game.window.y
		return true if x < (@x*32 + 32) && x > @x*32 && y < (@y*32 + 32) && y > @y*32
	end
	def select_
		@selected=true
		$game.board.piece_selected = self
	end
	def deselect
		@selected=false
		$game.board.piece_selected = nil
	end
	def selected?; @selected;       end
	def dead?
		@status == :alive ? false : true
	end
	def kill; @status = :dead; end
	#def selected?; @selected; end
end

class Chess::Board
	attr_reader :black, :white
	attr_accessor :piece_selected
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
		@black.each { |piece| piece.draw unless piece.dead? }
		@white.each { |piece| piece.draw unless piece.dead? }
	end
end

def IMG(file)
	Gosu::Image.new("./media/#{file}")
end
def TILES(file, w = 32, h = 32)
	h = w if !w.nil?
	Gosu::Image.load_tiles("./media/#{file}", w, h)
end
def TEXT(str, ht = 40) #add font later
	Gosu::Image.from_text(str, ht)
end

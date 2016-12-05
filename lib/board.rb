# board.rb

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
	end
	# empties the board.
	def clear
		puts "[!] Clearing the board."
		@grid.each do |y, row|
			row.each_key do |x|
				@grid[y][x] = nil
			end
		end
	end
	# creates pieces as they would be in a regular game
	def populate
		puts "[!] Populating the board."
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
				@grid[y][x].draw unless @grid[y][x].nil?
			end
		end
	end
end
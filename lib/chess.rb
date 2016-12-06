# chess.rb

class Chess
	attr_accessor :player, :x, :y, :moving, :has_selected
	attr_reader :selected_xy, :turn, :board, :window, :input
	def initialize
		@board  = Chess::Board.new
		@window = Chess::Window.new
		@input  = Chess::Input.new
		@board.populate
		
		@player = :white
		@x = @y = 3
		@moving = false
		@has_selected = false
		@selected_xy = [nil,nil]
		@turn = 0
	end
	def start;@window.show;end
	def stop;exit;end
	def reset
		puts
		puts "[!] RESETTING BOARD"
		@turn = 0
		@player = :white
		@has_selected = false
		@selected_xy = [nil,nil]
		@board.clear
		@board.populate
	end
	def end_turn
		@player == :white ? @player = :black : @player = :white
		@turn += 1
	end
	def up
		unless @y - 1 < 0
			@y -= 1 unless @moving
			@moving = true
		end
	end
	def down
		unless @y + 1 > 7
			@y += 1 unless @moving
			@moving = true
		end
	end
	def left
		unless @x - 1 < 0
			@x -= 1 unless @moving
			@moving = true
		end
	end
	def right
		unless @x + 1 > 7
			@x += 1 unless @moving
			@moving = true
		end
	end
	def get_piece(_x, _y); $game.board.grid[_y][_x]; end
	def find_xy(piece_obj)
		$game.board.grid.each do |y, row|
			row.each_key do |x|
				return [x, y] if $game.board.grid[y][x] == piece_obj
			end
		end
	end
	def select_piece(_x, _y)
		unless @has_selected
			$game.board.grid.each do |y, row|
				row.each do |x, item|
					if _x == x && _y == y && !$game.board.grid[y][x].nil? && $game.board.grid[y][x].color == @player
						break if @has_selected # idk it works
						@selected_xy = [x, y]
						@has_selected = true
						@moving = true
					end
				end
			end
		end
	end
	def deselect
		if @has_selected
			@selected_xy = [nil, nil]
			@has_selected = false
		end
	end
end
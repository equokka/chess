# chess.rb

class Chess
	attr_accessor :window, :board, :player, :input, :x, :y, :moving, :has_selected
	attr_reader :selected_xy, :turn
	def initialize()
		@player = :white
		@x = @y = 3
		@moving = false
		@has_selected = false
		@selected_xy = [nil,nil]
		@turn = 0
	end
	def start;@window.show;end
	def stop;exit;end
	def end_turn
		@player == :white ? @player = :black : @player = :white
		@turn += 1
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
	def select_piece(_x, _y)
		unless @has_selected
			$game.board.grid.each do |y, row|
				row.each do |x, item|
					if _x == x && _y == y && !$game.board.grid[y][x].nil?
						if $game.board.grid[y][x].color == @player
							break if @has_selected # idk it works
							@selected_xy = [x, y]
							@has_selected = true
							@moving = true
						end
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
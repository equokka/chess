# move.rb

class Chess
	def move_piece(_x, _y) #assumes there's a piece selected
		return nil if @selected_xy.nil? || @selected_xy.empty?
		return nil if $game.board.grid.nil?
		#raise "ERROR: tried to move out of bounds (from #{@selected_xy[0]},#{@selected_xy[1]}) (vector #{_x},#{_y})" if @selected_xy[0] + _x > 7 || @selected_xy[0] + _x < 0 || @selected_xy[1] + _y > 7 || @selected_xy[1] + _y < 0
		x_o = @selected_xy[0]
		y_o = @selected_xy[1]
		do_thing = Proc.new {
			$game.board.grid[_y][_x] = $game.get_piece x_o, y_o
			$game.board.grid[y_o][x_o] = nil
			puts "[!] moved to [#{@x},#{@y}]"
			deselect
			end_turn
		}
		#TODO finish this thing!!!!!!!!!!
		unless [_x, _y] == $game.selected_xy || !$game.board.grid[_y][_x].nil?
			# NOTE first turns are 0 for white and 1 for black
			case $game.board.grid[y_o][x_o].type
			when :pawn #TODO kill other pieces? get on it
				if $game.board.grid[y_o][x_o].color == :white
					if $game.board.grid[y_o][x_o].pawn_double_step
						if y_o <= _y + 2 && x_o == _x
							$game.board.grid[y_o][x_o].pawn_double_step = false
							do_thing.call
						end
					else
						do_thing.call if y_o == _y + 1 && x_o == _x
					end
				else
					if $game.board.grid[y_o][x_o].pawn_double_step
						if y_o >= _y - 2 && x_o == _x
							$game.board.grid[y_o][x_o].pawn_double_step = false
							do_thing.call
						end
					else
						do_thing.call if y_o == _y - 1 && x_o == _x
					end
				end
			when :rook
				if true
					
				end
			when :knight
				if true
					
				end
			when :bishop
				if true
					
				end
			when :queen
				if true
					
				end
			when :king
				if true
					
				end
			end
		end
	end
end
# move.rb

class Chess
	def move_piece(_x, _y) #assumes there's a piece selected
		return nil if @selected_xy.nil? || @selected_xy.empty?
		moved = false
		x_o = @selected_xy[0]
		y_o = @selected_xy[1]
		return nil if $game.board.grid.nil?
		return nil if $game.board.grid[y_o].nil?
		return nil if $game.board.grid[y_o][x_o].nil?
		#raise "ERROR: tried to move out of bounds (from #{@selected_xy[0]},#{@selected_xy[1]}) (vector #{_x},#{_y})" if @selected_xy[0] + _x > 7 || @selected_xy[0] + _x < 0 || @selected_xy[1] + _y > 7 || @selected_xy[1] + _y < 0
		do_thing = Proc.new {
			puts "[!] #{$game.board.grid[y_o][x_o].color} #{$game.board.grid[y_o][x_o].type} #{t_x x_o}#{y_o+1} => #{t_x _x}#{_y+1}"
			moved = true
			$game.board.grid[_y][_x] = $game.get_piece x_o, y_o
			$game.board.grid[y_o][x_o] = nil
			deselect
			end_turn
		}
		# TODO finish this thing!!!!!!!!

		# x_o, y_o => origin
		# _x, _y   => destination
		# opposite => opposite piece color

		# set which pieces the piece can kill
		$game.board.grid[y_o][x_o].color == :white ? opposite = :black : opposite = :white

		if [_x, _y] != $game.selected_xy || $game.board.grid[_y][_x].nil? || (!$game.board.grid[_y][_x].nil? && $game.board.grid[_y][_x].color == opposite)
			case $game.board.grid[y_o][x_o].type
			when :pawn
				# decide which way is forward for the pawn based on color
				$game.board.grid[y_o][x_o].color == :white ? forward = 1 : forward = -1
				if x_o != _x # check if we're trying to move diagonally
					# check if you can kill
					# (i have no clue why it wouldn't work with +forward but whatever)
					if !$game.board.grid[_y][_x].nil? && $game.board.grid[_y][_x].color == opposite && _y == y_o -forward && (_x == x_o + 1 || _x == x_o - 1)
						do_thing.call
					end
				else # we're not moving diagonally
					if $game.board.grid[y_o][x_o].pawn_double_step # can the pawn jump two cells?
						if (y_o == _y +forward*2 || y_o == _y +forward) && x_o == _x # is the pawn moving forward 2 cells?
							do_thing.call if $game.board.grid[_y][_x].nil?
						else # it isn't
							do_thing.call if y_o == _y +forward && x_o == _x && $game.board.grid[_y][_x].nil?
						end
					else # pawn can't jump two cells, so we just check if it's moving one cell
						do_thing.call if y_o == _y +forward && x_o == _x && $game.board.grid[_y][_x].nil?
					end
				end
				# promotion
				if moved
					if (opposite == :black && _y == 0) || (opposite == :white && _y == 7)
						$game.board.grid[_y][_x].type = :queen #TODO create UI for selecting promoted piece
						$game.board.grid[_y][_x].update_type # refresh sprite to reflect type change
					elsif $game.board.grid[_y][_x].pawn_double_step # make sure pawn can't jump 2 cells if it's moved before
						$game.board.grid[_y][_x].pawn_double_step = false
					end
				end #TODO ADD EN PASSANT
			when :rook
				# TODO castling
				
				# check if the path is not diagonal
				#  (_x != x_o && _y == y_o) || (_x == x_o && _y != y_o)
				#         horizontal                  vertical
				if _x != x_o && _y == y_o
					row = $game.board.grid[y_o].to_a
					row.each { |ary| ary.shift }
					row.flatten!
					if _x > x_o # headed right
						path = row[x_o.._x]
					elsif _x < x_o # headed left
						path = row[_x..x_o] # reversed path
					end
					path.shift if path.length > 1 # remove first in array
					path.pop # remove last in array
					if path.uniq.length == 1 && path.include?(nil) # check if path is clear
						do_thing.call if $game.board.grid[_y][_x].nil? || $game.board.grid[_y][_x].color == opposite
					end
				elsif _x == x_o && _y != y_o
					path = []
					if _y > y_o # headed down
						collumn = (y_o.._y).to_a
					elsif _y < y_o # headed up
						collumn = (_y..y_o).to_a
					end
					collumn.each do |i|
						path << $game.board.grid[i][x_o]
					end
					path.shift if path.length > 1  # remove first in array
					path.pop   # remove last in array
					if path.uniq.length == 1 && path.include?(nil) # check if path is clear
						do_thing.call if $game.board.grid[_y][_x].nil? || $game.board.grid[_y][_x].color == opposite
					end
				end
			when :knight
				puts "[W] moved a piece with no movement restrictions!"
				do_thing.call
			when :bishop
				puts "[W] moved a piece with no movement restrictions!"
				do_thing.call
			when :queen
				puts "[W] moved a piece with no movement restrictions!"
				do_thing.call
			when :king
				# TODO check if the destination will not place the king in check
				# TODO castling (need to fix rook first)
				# check if we're moving horizontally or vertically
				if ((x_o == _x + 1 || x_o == _x - 1) && y_o == _y) || ((y_o == _y + 1 || y_o == _y - 1) && x_o == _x)
					do_thing.call
				# check if we're instead moving diagonally
				elsif (x_o == _x + 1 && y_o == _y + 1) || (x_o == _x - 1 && y_o == _y + 1) || (x_o == _x + 1 && y_o == _y - 1) || (x_o == _x - 1 && y_o == _y - 1)
					do_thing.call
				end
			end
		end
	end
end
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
			moved = true
			$game.board.grid[_y][_x] = $game.get_piece x_o, y_o
			$game.board.grid[y_o][x_o] = nil
			puts "[!] moved to [#{@x},#{@y}]"
			deselect
			end_turn
		}
		# TODO finish this thing!!!!!!!!

		# x_o, y_o => origin
		# _x, _y   => destination
		# opposite => opposite piece color

		# set which pieces the piece can kill
		$game.board.grid[y_o][x_o].color == :white ? opposite = :black : opposite = :white

		if [_x, _y] != $game.selected_xy || $game.board.grid[_y][_x].nil? || ( !$game.board.grid[_y][_x].nil? && $game.board.grid[_y][_x].color == opposite)
			case $game.board.grid[y_o][x_o].type
			when :pawn
				# decide which way is forward for the pawn based on color
				$game.board.grid[y_o][x_o].color == :white ? forward = 1 : forward = -1
				if x_o != _x # check if we're trying to move diagonally
					# check if you can kill
					# (i have no clue why it wouldn't work with +forward but whatever)
					if !$game.board.grid[_y][_x].nil? && $game.board.grid[_y][_x].color == opposite && _y == y_o -forward && (_x == x_o + 1 || _x == x_o - 1)
						$game.board.grid[_y][_x] = nil # kill the other piece before moving+ending turn
						do_thing.call
					end
				else # we're not moving diagonally
					if $game.board.grid[y_o][x_o].pawn_double_step # can the pawn jump two cells?
						if (y_o == _y +forward*2 || y_o == _y +forward) && x_o == _x # is the pawn moving forward 2 cells?
							do_thing.call
						else # it isn't
							do_thing.call if y_o == _y +forward && x_o == _x
						end
					else # pawn can't jump two cells, so we just check if it's moving one cell
						do_thing.call if y_o == _y +forward && x_o == _x
					end
				end
				# promotion
				if moved
					if (opposite == :black && _y == 0) || (opposite == :white && _y == 7)
						$game.board.grid[_y][_x].type = :queen #TODO create UI for selecting promoted piece
					elsif $game.board.grid[_y][_x].pawn_double_step # make sure pawn can't jump 2 cells if it's moved before
						$game.board.grid[_y][_x].pawn_double_step = false
					end
				end #TODO ADD EN PASSANT
			when :rook
				possible = true # this variable is used to check if a path is unobstrtucted
				if x_o == _x && y_o != _y # moving vertically
					y_o < _y ? path = y_o.._y : _y..y_o
					path = path.to_a
					path.slice!(1..path.length - 1)
					# iterate over every cell between piece and desired destination
					# excluding the above mentioned
					path.each do |y|
						# make moving impossible if we find a single obstacle on the way
						possible = false unless $game.board.grid[y][x_o].nil?
					end
				elsif y_o == _y && x_o != _x # moving horizontally
					x_o < _x ? path = x_o.._x : _x..x_o
					path = path.to_a
					path.slice!(1..path.length - 1)
					# iterate over every cell between piece and desired destination
					# excluding the above mentioned
					path.each do |x|
						# make moving impossible if we find a single obstacle on the way
						possible = false unless $game.board.grid[y_o][x].nil?
					end
				end
				# this block runs if the path is clear
				if possible
					# check if there's a piece in the destination cell
					if $game.board.grid[_y][_x].nil? # nothing there
						do_thing.call
					else # something there
						# check if it's an enemy
						if $game.board.grid[_y][_x].color == opposite
							$game.board.grid[_y][_x] = nil
							do_thing.call
						end
					end
				end	#TODO ADD CASTLING
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
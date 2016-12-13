# debug.rb
# this code is executed just before calling Chess#start
# one example of this is adding pieces to the board
# via $game.board.grid[y][x] = Chess::Piece.new :type, :color

$game.board.clear
$game.board.grid[3][3] = Chess::Piece.new :rook, :white
$game.board.grid[4][4] = Chess::Piece.new :king, :white
$game.board.grid[0][0] = Chess::Piece.new :king, :black

# call this every Chess::Window#update
$debug_window = Proc.new {

	# hacky commandline access
	$game.input.queue :period, Proc.new {
		unless $game.moving
			$game.moving = true
			loop do
				print "> "
				cmd = gets.strip
				if cmd == "exit"
					puts
					break
				end
				begin
					p eval cmd
				# i think this is ok as long as i'm just debugging
				rescue Exception => e
					puts "> Error:"
					puts e
				end
			end
		end
	}
}
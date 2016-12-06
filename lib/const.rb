# const.rb

def IMG(file)
	Gosu::Image.new("./media/#{file}")
end
def TILES(file, w = 32, h = 32)
	h = w if !w.nil?
	Gosu::Image.load_tiles("./media/#{file}", w, h)
end
def TEXT(str, ht = 32) #add font later
	Gosu::Image.from_text(str, ht)
end

def print_board
	puts "\n   /#{"-"*103}\\"
	$game.board.grid.each do |y, row|
		print " #{y+1} | "
		row.each_key do |x|
			print " | " if x>0
			print "  (      )" if $game.board.grid[y][x].nil?
			print "#{$game.board.grid[y][x]}" unless $game.board.grid[y][x].nil?
		end
		puts " |"
	end
	print "   \\#{"-"*103}/\n     "
	8.times { |i| print "[---#{(t_x i)*2}---]   " }
	puts
end


# translate x position into file.
# chess positions are annotated with file,rank, analogous to x,y
def t_x(x)
	{   0 => "a",
		1 => "b",
		2 => "c",
		3 => "d",
		4 => "e",
		5 => "f",
		6 => "g",
		7 => "h" }[x]
end

Chess::DEFAULT_WIDTH  = 1*32 + 8*32 + 5*32
Chess::DEFAULT_HEIGHT = 8*32 + 1*32
Chess::DEFAULT_TITLE  = %q{CHESS 2}
Chess::DRAW_OFFSET    = [32, 0]
Chess::TILESET        = TILES("tileset.png")
Chess::KEYBOARD       = {
	:up    => Gosu::KbUp,
	:down  => Gosu::KbDown,
	:left  => Gosu::KbLeft,
	:right => Gosu::KbRight,
	:space => Gosu::KbSpace,
	:esc   => Gosu::KbEscape,
	:q     => Gosu::KbQ,
	:e     => Gosu::KbE
}
Chess::DEFAULT_DELAY = 10

# const.rb

class Chess;end

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

def DEBUG
	$game.board.grid.each do |y, row|
		print "#{y} = {"
		row.each_key do |x|
			print ", " if x>0
			print "#{$game.board.grid[y][x]}"
		end
		puts "}"
	end
end



Chess::DEFAULT_WIDTH  = 256 + 128
Chess::DEFAULT_HEIGHT = 256
Chess::DEFAULT_TITLE  = %q{Chess but bad}
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

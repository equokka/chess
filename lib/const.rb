# const.rb
class Chess;end
Chess::DEFAULT_WIDTH  = 256 + 128
Chess::DEFAULT_HEIGHT = 256
Chess::DEFAULT_TITLE  = %q{Chess but bad}
Chess::CHESSPIECES    = TILES("chess-pieces.png")
Chess::KEYBOARD       = {
	:up => Gosu::KbUp,
	:down => Gosu::KbDown,
	:left => Gosu::KbLeft,
	:right => Gosu::KbRight
}
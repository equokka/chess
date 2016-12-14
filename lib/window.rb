# window.rb

class Chess::Window < Gosu::Window
	attr_accessor :state, :width, :height, :timeout
	def initialize(w = Chess::DEFAULT_WIDTH, h = Chess::DEFAULT_HEIGHT)
		super w, h, false
		@width = w
		@height = h
		@state = :menu
		self.caption = Chess::DEFAULT_TITLE

		#img
		@bg        = IMG("bg.png")
		@path_ok   = Chess::TILESET[12]
		@hovered   = Chess::TILESET[13]
		@selected  = Chess::TILESET[14]
		@t_wait    = TEXT("waiting")
		@t_play    = TEXT("playing")
		@b_files   = []
		@b_ranks   = []
		8.times do |i|
			@b_files << TEXT(t_x(i))
			@b_ranks << TEXT(i+1)
		end
		# @t_c_piece, @t_turn defined in #update
	end
	def update
		@timeout = 0 if @timeout.nil?
		self.caption = Chess::DEFAULT_TITLE + " - [FPS: #{Gosu::fps.to_s}] [#{Chess::DEFAULT_DELAY - @timeout}]"
		
		$game.input.queue :up,    Proc.new {$game.up}
		$game.input.queue :down,  Proc.new {$game.down}
		$game.input.queue :left,  Proc.new {$game.left}
		$game.input.queue :right, Proc.new {$game.right}
		if !$game.has_selected
			$game.input.queue :space, Proc.new {$game.select_piece $game.x, $game.y}
		elsif $game.has_selected && !$game.moving
			$game.input.queue :q,     Proc.new {$game.deselect}
			$game.input.queue :space, Proc.new {$game.move_piece $game.x, $game.y}
		end

		$game.input.queue :esc, Proc.new {puts "[!] game stopped via Escape key";$game.stop}

		@timeout += 1 unless @timeout == Chess::DEFAULT_DELAY if $game.moving
		if @timeout == Chess::DEFAULT_DELAY
			@timeout = 0
			$game.moving = false
		end

		$debug_window.call

		#do things here
		@t_c_piece = TEXT("[#{t_x $game.x}#{$game.y+1}]")
		@t_turn    = TEXT("Turn #{$game.turn}")
		$game.input.update
	end

	def c_w; @width/2;     end
	def c_h; @height/2;    end
	def x;   self.mouse_x; end
	def y;   self.mouse_y; end

	def draw
		d_x = Chess::DRAW_OFFSET[0]
		d_y = Chess::DRAW_OFFSET[1]

		$game.board.draw
		@bg.draw         0 + d_x,          0 + d_y,          0
		@hovered.draw    $game.x*32 + d_x, $game.y*32 + d_y, 3

		@t_c_piece.draw  8*32 + 5 + d_x,   3*32 + d_y,       4
		@t_turn.draw     8*32 + 5 + d_x,   4*32 + d_y,       4

		case $game.player
		when :white
			@t_wait.draw 8*32 + 5 + d_x,   0 + d_y,          4
			@t_play.draw 8*32 + 5 + d_x,   7*32 + d_y,       4
		when :black
			@t_wait.draw 8*32 + 5 + d_x,   7*32 + d_y,       4
			@t_play.draw 8*32 + 5 + d_x,   0 + d_y,          4
		end

		if $game.has_selected
			@selected.draw $game.selected_xy[0]*32 + d_x, $game.selected_xy[1]*32 + d_y, 3
			@path_ok.draw  $game.x * 32 + d_x,            $game.y * 32 + d_y,            3 unless $game.x == $game.selected_xy[0] && $game.y == $game.selected_xy[1]
		end

		8.times do |i|
			@b_files[i].draw i*32 + d_x + 8, 8*32 - 2 + d_y, 0
			@b_ranks[i].draw 8 + d_x - 1*32,    i*32 + d_y,     0
		end
	end
end


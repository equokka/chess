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
		self.caption = Chess::DEFAULT_TITLE + " - [FPS: #{Gosu::fps.to_s}] [#{$game.x},#{$game.y}] [#{Chess::DEFAULT_DELAY - @timeout}] [#{$game.selected_xy[0]},#{$game.selected_xy[1]}]"
		
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
		
		$game.input.queue :e, Proc.new {
			print_board unless $game.moving
			$game.moving = true
		}

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
		@bg.draw 0 + Chess::DRAW_OFFSET[0], 0 + Chess::DRAW_OFFSET[1], 0
		#@cursor.draw self.x - 9 , self.y + 5, 10
		$game.board.draw
		@hovered.draw $game.x * 32 + Chess::DRAW_OFFSET[0], $game.y * 32 + Chess::DRAW_OFFSET[1], 3

		@t_c_piece.draw 8*32 + 5 + Chess::DRAW_OFFSET[0], 3*32 + Chess::DRAW_OFFSET[1], 4
		@t_turn.draw 8*32 + 5 + Chess::DRAW_OFFSET[0], 4*32 + Chess::DRAW_OFFSET[1], 4

		case $game.player
		when :white
			@t_wait.draw 8*32 + 5 + Chess::DRAW_OFFSET[0], 0 + Chess::DRAW_OFFSET[1], 4
			@t_play.draw 8*32 + 5 + Chess::DRAW_OFFSET[0], 7*32 + Chess::DRAW_OFFSET[1], 4
		when :black
			@t_wait.draw 8*32 + 5 + Chess::DRAW_OFFSET[0], 7*32 + Chess::DRAW_OFFSET[1], 4
			@t_play.draw 8*32 + 5 + Chess::DRAW_OFFSET[0], 0 + Chess::DRAW_OFFSET[1], 4
		end

		if $game.has_selected
			@selected.draw $game.selected_xy[0]*32 + Chess::DRAW_OFFSET[0], $game.selected_xy[1]*32 + Chess::DRAW_OFFSET[1], 3
			@path_ok.draw $game.x * 32 + Chess::DRAW_OFFSET[0], $game.y * 32 + Chess::DRAW_OFFSET[1], 3 unless $game.x == $game.selected_xy[0] && $game.y == $game.selected_xy[1]
		end

		8.times do |i|
			@b_files[i].draw i*32 + Chess::DRAW_OFFSET[0] + 8, 8*32 - 2 + Chess::DRAW_OFFSET[1], 0
			@b_ranks[i].draw 0 + 8, i*32 + Chess::DRAW_OFFSET[1], 0
		end
	end
end


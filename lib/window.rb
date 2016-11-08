# window.rb
class Chess::Window < Gosu::Window
	attr_accessor :state, :width, :height
	def initialize(w = Chess::DEFAULT_WIDTH, h = Chess::DEFAULT_HEIGHT)
		super w, h, false
		@width = w
		@height = h
		@state = :menu
		self.caption = Chess::DEFAULT_TITLE
		puts "width:#{w}, height:#{h}"

		#img
		@bg       = IMG("bg.png")
		@cursor   = IMG("cursor.png")
		@hovered  = IMG("hovered.png")
		@selected = IMG("selected.png")
	end
	def update
		timeout = 0 if timeout.nil? || timeout >= (Gosu::fps)
		self.caption = Chess::DEFAULT_TITLE + " - [FPS: #{Gosu::fps.to_s}] [#{$game.x},#{$game.y}] [#{timeout}]"
		$game.input.queue :up,    Proc.new {$game.up}    if !$game.moving
		$game.input.queue :down,  Proc.new {$game.down}  if !$game.moving
		$game.input.queue :left,  Proc.new {$game.left}  if !$game.moving
		$game.input.queue :right, Proc.new {$game.right} if !$game.moving
		
		#FIX THIS 
		if $game.moving && timeout != Gosu::fps
			timeout += 1
		else
			timeout = 0
			$game.moving = false
		end
		

		$game.input.update
	end
	def caption_update

	end
	def c_w; @width/2;     end
	def c_h; @height/2;    end
	def x;   self.mouse_x; end
	def y;   self.mouse_y; end

	def draw
		@bg.draw 0,0,0
		#@cursor.draw self.x - 9 , self.y + 5, 10
		$game.board.draw
		$game.board.black.each do |piece|
			if piece.hovered? && !piece.dead?
				@hovered.draw piece.x * 32, piece.y * 32, 2
			end
		end
	end
end


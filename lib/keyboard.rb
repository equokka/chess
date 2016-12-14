# keyboard.rb

class Chess::Input
	attr_reader :events, :keyboard
	def initialize
		@events = {}
		@keyboard = {
			:up     => Gosu::KbUp,
			:down   => Gosu::KbDown,
			:left   => Gosu::KbLeft,
			:right  => Gosu::KbRight,
			:space  => Gosu::KbSpace,
			:esc    => Gosu::KbEscape,
			:q      => Gosu::KbQ
		}
		@keyboard.each { |key| @events[key[0]] = [] }
	end
	def [](key)
		@keyboard[key]
	end
	def []=(key, gosu_key)
		puts "added #{key}"
		@keyboard[key] = gosu_key
		@events[key] = []
		puts @events.to_s
	end
	def update
		@events.each do |key|
			if Gosu.button_down? @keyboard[key[0]]
				@events[key[0]].each do |event|
					event.call
					@events[key[0]].shift
				end
			end
		end
	end
	def queue(key, event)
		raise "tried to call Chess::Input#queue with something other than a Proc" unless event.is_a?(Proc) || event.nil?
		@events[key] << event unless @events[key].nil? || $game.moving
	end
end
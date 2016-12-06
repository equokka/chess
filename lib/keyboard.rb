# keyboard.rb

class Chess::Input
	attr_reader :events
	def initialize
		@events = {}
		Chess::KEYBOARD.each { |key| @events[key[0]] = [] }
	end
	def update
		@events.each do |key|
			if Gosu.button_down? Chess::KEYBOARD[key[0]]
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
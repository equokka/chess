# main.rb

require 'gosu'
require_relative 'lib/chess'
require_relative 'lib/piece'
require_relative 'lib/board'
require_relative 'lib/move'
require_relative 'lib/const'
require_relative 'lib/window'
require_relative 'lib/keyboard'

$game = Chess.new

require_relative 'debug'

$game.start
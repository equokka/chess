# main.rb

require 'gosu'
require_relative 'lib/chess'
require_relative 'lib/const'
require_relative 'lib/window'
require_relative 'lib/keyboard'

$game = Chess.new
$game.window = Chess::Window.new
$game.board = Chess::Board.new
$game.input = Chess::Input.new

$game.start
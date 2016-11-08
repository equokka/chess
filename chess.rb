# chess.rb

require 'gosu'
require_relative 'lib/chess'
require_relative 'lib/const'
require_relative 'lib/window'

$game = Chess.new
$game.window = Chess::Window.new
$game.board = Chess::Board.new
$game.start
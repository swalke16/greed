$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")
require 'greed_console'

game_ui = Greed::UI::Console.new(Greed::Game.new())
game_ui.play()
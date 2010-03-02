require 'greed/console_player_strategy'

module Greed
  module Players
    class SimpleAIConsolePlayerStrategy < ConsolePlayerStrategy
       def wants_to_roll_again?(player, turn_score, dice_left_to_roll)
        true
       end
    end
  end
end
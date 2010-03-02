require 'greed/console_player_strategy'

module Greed
  module Players
    class HumanConsolePlayerStrategy < ConsolePlayerStrategy
       def wants_to_roll_again?(player, turn_score, dice_left_to_roll)
         @terminal.agree(%{In Game: <%= color('#{player.in_game}', :yellow) %> Game Score: <%= color('#{player.score}', :yellow) %> Turn Score: <%= color('#{turn_score}', :yellow) %> There are <%= color('#{dice_left_to_roll}', :cyan) %> dice left to roll. Roll dice? <%= color('(y/n)', :cyan) %> }, true) do |q|
           q.overwrite = true
           q.echo      = false  # overwrite works best when echo is false.
           q.character = true   # if this is set to :getc then overwrite does not work
         end
       end
    end
  end
end
module Greed
  module Players
    class ConsolePlayerStrategy 
      def initialize(terminal)
        @terminal = terminal
      end
  
      def lost_turn(player)
        @terminal.say("<%= color('#{player.name} rolled a zero so #{player.name} lost their turn and any accumulated score for this turn.', :red) %>")
        @terminal.say("\n")
      end
  
      def begin_turn(player)
        @terminal.say(%{<%= color("#{player.name}'s", :yellow) %> turn is beginning!})
      end

      def end_turn(player, turn_score)
        @terminal.say(%{<%= color("#{player.name}'s", :yellow) %> turn has now ended! #{player.name} scored a total of <%= color('#{turn_score}', :green) %> points for this turn!})
        @terminal.say("\n")
      end  
    end
  end
end
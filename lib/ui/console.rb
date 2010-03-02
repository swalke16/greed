# TODO: create another UI on top

require 'rubygems'
require 'highline'
require 'greed'

module Greed
  module UI
    class Console
      def initialize(greed_game_engine)
        @game_engine = greed_game_engine
        @terminal = HighLine.new
      end

      def play()
        display_game_info()
        players = prompt_for_players()
    
        begin
          @game_engine.play(self, players)
          display_game_summary()
        rescue ArgumentError => error
          @terminal.say("\n")
          @terminal.say(%{<%= color("#{error}", :red) %>})
        end      
      end

      def entering_final_round(leading_player)
        @terminal.say(%{
    <%= color('#{leading_player.name}', :yellow) %> has scored greater than 3000 points!
    The game is now entering the final round in which all players except <%= color('#{leading_player.name}', :yellow) %> will have one final turn.})
        @terminal.say("\n")
      end

    private
      def display_game_info()
        @terminal.say("\n")
        @terminal.say("Welcome to the game of <%= color('Greed', :green) %>!")
        @terminal.say("\n")
      end

      def prompt_for_players()
        prompt_for_human_players() + prompt_for_ai_players()
      end

      def prompt_for_human_players()
        @terminal.say("Please enter player names, or a blank name to stop creating players.")

        players = []
        player_name = nil
        begin
          while player_name != ""
            player_name = @terminal.ask("Enter player <%= color('#{players.length + 1}', :yellow) %> name: ")
            players << player_name unless player_name == ""
          end
        rescue EOFError
        end

        @terminal.say("\n")

        players.map {|name| Greed::Players::Player.new(name, Greed::Players::HumanConsolePlayerStrategy.new(@terminal))}
      end
  
      def prompt_for_ai_players()
        ai_player_count = @terminal.ask("How any computer players would you like to play the game? ", Integer) do |q|
          q.validate = lambda { |p| p.to_i >= 0 }
          q.responses[:not_valid] = "0 is the minumum number of allowed computer players!"
        end
        @terminal.say("\n")    
    
        (1..ai_player_count).map {|i| Greed::Players::Player.new("Computer #" + i.to_s, Greed::Players::SimpleAIConsolePlayerStrategy.new(@terminal))}
      end  

      def display_game_summary()
        @terminal.say("The game has now ended!")

        winning_player = @game_engine.players.inject {|lead, player| player.score > lead.score ? player : lead}
        summary = @game_engine.players.inject("Game Summary:\n") do |text, player|
           text << "<%= color('#{player.name}', :yellow) %> scored: <%= color('#{player.score}', :yellow) %> points."
           text << "<%= BLINK %><%= color(' <-- WINNER!', :magenta) %><%= CLEAR %>" if player == winning_player
           text << "\n"
        end

        @terminal.say(summary)
        @terminal.say("\n")
      end
    end
  end
end
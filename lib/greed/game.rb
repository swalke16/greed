module Greed
  class Game
    attr_reader :players

    def initialize()
      @players = nil
      @game_ui = nil
    end

    def play(game_ui, players)
      @game_ui = game_ui
      raise(ArgumentError, "Two or more players are required to play the game!") if players == nil || players.length < 2
      @players = players

      # process rounds 1...N
      while !is_final_round?
        give_all_players_a_turn_unless {is_final_round?}
      end

      # process final round
      leading_player = player_has_winning_score?
      notify_final_round(leading_player)
      give_all_players_a_turn_unless {|player| player == leading_player}

    end

    private
    def give_all_players_a_turn_unless (&skip_player)
     @players.each {|player| player.play_turn(DiceSet.new(5)) if !yield(player) }
    end

    def is_final_round?
      player_has_winning_score? != nil
    end

    def player_has_winning_score?
      players = @players.select {|player| player.score >= 3000}
      players.length > 0 ? players[0] : nil
    end

    def notify_final_round(leading_player)
      if @game_ui.respond_to?(:entering_final_round)
        @game_ui.send(:entering_final_round, leading_player)
      end
    end
  end
end
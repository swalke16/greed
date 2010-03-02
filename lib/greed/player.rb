module Greed
  module Players
    class Player
      attr_reader :name
      attr_reader :score
      attr_reader :in_game

      def initialize(name, player_strategy)
        @name = name
        @score = 0
        @in_game = false
        @player_strategy = player_strategy
      end

      def play_turn(dice)
        @player_strategy.begin_turn(self)
    
        turn_score = 0
          
        while i_have_dice_left_to_roll?(dice) && i_want_to_continue_rolling?(turn_score, dice)
          dice.roll()
          if dice.score == 0
            @player_strategy.lost_turn(self)
            return
          else
            turn_score += dice.score
          end            
        end
    
        update_score(turn_score)
        @player_strategy.end_turn(self, turn_score)
      end

      def update_score(points)
        @in_game = true if points >= 300 && !@in_game
        @score += points unless !@in_game
      end  
    
    private
      def i_have_dice_left_to_roll?(dice)
        dice.left_to_roll > 0
      end
  
      def i_want_to_continue_rolling?(turn_score, dice)
        @player_strategy.wants_to_roll_again?(self, turn_score, dice.left_to_roll)
      end 
    end
  end
end
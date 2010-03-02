module Greed
  class DiceSet
    attr_reader :values
    attr_reader :score
    attr_reader :left_to_roll

    def initialize(number_of_dice)
      @score = 0
      @values = []
      @left_to_roll = number_of_dice
    end

    def roll()
      @values = (1..@left_to_roll).map { rand(6) + 1 }
      @score, @left_to_roll =  calculate_score(values)
      @left_to_roll = 0 if @score == 0
    end

    def calculate_score(values)
      digit_counts = count_digits(values)
      digit_scores = digit_counts.inject({}){|h,(k,v)| h[k] = score_for_digit(k,v); h }
      roll_score = digit_scores.values.inject(0){|sum,item| sum + item}
      non_scoring_count = digit_scores.inject(0){|sum,(k,v)| v==0 ? sum + digit_counts[k] : sum}
      return roll_score, non_scoring_count
    end

  private
    def count_digits(dice)
      digit_counts = Hash.new(0)
      dice.each{ |item| digit_counts[item] += 1 }

      return digit_counts
    end

    def score_for_digit(digit, count)
      score=0

      if count >= 3
        score += triple_digit_score(digit) + sum_digit_score(digit, count-3)
      else
        score += sum_digit_score(digit, count)
      end

      return score
    end

    def triple_digit_score(digit)
      if digit == 1
        1000
      else
        digit * 100
      end
    end

    def sum_digit_score(digit, count)
      if digit == 1
        count*100
      elsif digit == 5
        count*50
      else
        0
      end
    end
  end
end
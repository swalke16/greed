require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Greed
  module Players
    describe Player do
      context "when playing a turn" do
        before( :each ) do
          @player_strategy = flexmock("fake strategy", :begin_turn=>nil, :end_turn=>nil)
          @player = Player.new("anonymous", @player_strategy)
          @dice = flexmock("fake dice")
          @dice.should_ignore_missing
        end

        it "finishes when all dice are scoring dice" do
          @player_strategy.should_receive(:wants_to_roll_again?).and_return(true)
          @dice.should_receive(:score).and_return(650)
          @dice.should_receive(:left_to_roll).and_return(0)

          @player.play_turn(@dice)
        end

        it "finishes when player chooses not to roll more dice" do
          @player_strategy.should_receive(:wants_to_roll_again?).and_return(false)
          @dice.should_receive(:score).and_return(0)
          @dice.should_receive(:left_to_roll).and_return(5)

          @player.play_turn(@dice)
        end

        it "score equals sum of scores from all rolls during turn" do
          @player_strategy.should_receive(:wants_to_roll_again?).and_return(true, true, true, false)
          @dice.should_receive(:left_to_roll).and_return(1)
          @dice.should_receive(:score).and_return(250)

          @player.play_turn(@dice)

          @player.score.should eql(750)
        end

        it "loses turn and accumulates no points when a zero is rolled" do
          @player_strategy.should_receive(:wants_to_roll_again?).and_return(true)
          @player_strategy.should_receive(:lost_turn).once.with(@player)
          @dice.should_receive(:score).and_return(0)

          expected_score = @player.score
          @player.play_turn(@dice)

          @player.score.should eql(expected_score)
        end    
      end
  
      context "when beginning a turn" do
        it "should begin a turn" do
          player_strategy = flexmock("fake strategy", :end_turn=>nil)
          player_strategy.should_receive(:wants_to_roll_again?).and_return(false)
      
          dice = flexmock("fake dice")
          dice.should_ignore_missing
          player = Player.new("anonymous", player_strategy)
          player_strategy.should_receive(:begin_turn).once.with(player)
      
          player.play_turn(dice)
        end        
      end
  
      context "when ending a turn" do
        it "should end a turn" do
          player_strategy = flexmock("fake strategy", :begin_turn=>nil)
          player_strategy.should_receive(:wants_to_roll_again?).and_return(true,false)
          dice = flexmock("fake dice", :roll=>nil)
          dice.should_receive(:score).and_return(50)
          dice.should_receive(:left_to_roll).and_return(5)

          player = Player.new("anonymous", player_strategy)
          player_strategy.should_receive(:end_turn).once.with(player, 50)
      
          player.play_turn(dice)
        end        
      end
    end
  end
end
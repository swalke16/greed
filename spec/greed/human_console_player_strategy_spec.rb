require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Greed
  module Players
    describe HumanConsolePlayerStrategy do
      context "when asking if a player wants to roll again" do
        before(:each) do
          @terminal = flexmock("fake terminal")
          @player = flexmock(:name=>"fake player", :in_game=>true, :score=>50)
          @player_strategy = HumanConsolePlayerStrategy.new(@terminal)
        end
  
        it "returns true if the player typed a 'y'" do
          @terminal.should_receive(:agree).with(/There are.*3.*dice left to roll. Roll dice?/, true, Proc).once.and_return(true)
  
          roll_again = @player_strategy.wants_to_roll_again?(@player, 50, 3)    
  
          roll_again.should eql(true)
        end

        it "returns false if the player typed a 'n'" do
          @terminal.should_receive(:agree).with(/There are.*3.*dice left to roll. Roll dice?/, true, Proc).once.and_return(false)
  
          roll_again = @player_strategy.wants_to_roll_again?(@player, 50, 3)    
  
          roll_again.should eql(false)
        end
      end 
    end
  end
end
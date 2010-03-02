require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Greed
  module Players
    describe SimpleAIConsolePlayerStrategy do
      context "when asking if a player wants to roll again" do
        before(:each) do
          @terminal = flexmock("fake terminal")
          @player = flexmock(:name=>"fake player", :in_game=>true, :score=>50)
          @player_strategy = SimpleAIConsolePlayerStrategy.new(@terminal)
        end
  
        it "returns true" do
          roll_again = @player_strategy.wants_to_roll_again?(@player, 50, 3)    
  
          roll_again.should eql(true)
        end
      end
    end
  end
end
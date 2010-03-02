require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Greed
  module Players
    describe ConsolePlayerStrategy do 
      context "when a turn is beginning" do
        before(:each) do
          @terminal = flexmock("fake terminal")
          @player = flexmock(:name=>"fake player")
          @player_strategy = ConsolePlayerStrategy.new(@terminal)
        end

        it "displays the status of the turn if the turn was a scoring turn" do    
          @terminal.should_receive(:say).with(/#{@player.name}'s.*turn is beginning!/).once
          @terminal.should_receive(:say)

          @player_strategy.begin_turn(@player)
        end  
      end
 
      context "when a turn is ending" do
        before(:each) do
          @terminal = flexmock("fake terminal")
          @player = flexmock(:name=>"fake player")
          @player_strategy = ConsolePlayerStrategy.new(@terminal)
        end

        it "displays the status of the turn if the turn was a scoring turn" do    
          @terminal.should_receive(:say).with(/#{@player.name}'s.*turn has now ended! #{@player.name} scored a total of.*50/).once
          @terminal.should_receive(:say)
    
          @player_strategy.end_turn(@player, 50)
        end  
      end
  
      context "when a turn is lost" do
        before(:each) do
          @terminal = flexmock("fake terminal")
          @player = flexmock(:name=>"fake player")
          @player_strategy = ConsolePlayerStrategy.new(@terminal)
        end
    
        it "displays the lost turn message" do    
          @terminal.should_receive(:say).with(/#{@player.name} rolled a zero so #{@player.name} lost their turn and any accumulated score for this turn./).once
          @terminal.should_receive(:say)
    
          @player_strategy.lost_turn(@player)
        end
      end
    end
  end
end
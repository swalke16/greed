require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Greed
  module UI
    describe Console do  
      context "when playing" do
        before(:each) do            
          @terminal = flexmock("fake terminal") 
          flexmock(HighLine).should_receive(:new).and_return(@terminal)

          @game_engine = flexmock("fake game engine")
          @game_engine.should_ignore_missing
          @game_ui = Console.new(@game_engine)
        end

        def SetupPlayers(ai_count, *player_names)
          @terminal.should_receive(:ask).times(player_names.length).with(/Enter player/).and_return(*player_names)
          @terminal.should_receive(:ask).once.with(/How any computer players would you like to play the game?/, Integer, Proc).and_return(ai_count)      
        end

        it "prompts for human player names until no names entered" do
          SetupPlayers(0, "tom", "dick", "harry", "")
          @terminal.should_ignore_missing

          @game_ui.play()
        end
    
        it "prompts for the count of computer players in the game" do
          SetupPlayers(1, "")
          @terminal.should_ignore_missing

          @game_ui.play()
        end

        it "plays the game with the combination of human and computer players that were entered"  do
          SetupPlayers(1, "tom", "dick", "harry", "")
          @terminal.should_ignore_missing
      
          @game_engine.
            should_receive(:play).
            with(@game_ui, FlexMock.on {|arg| arg.length == 4 && arg[0].name == "tom" && arg[1].name == "dick" && arg[2].name == "harry" && arg[3].name == "Computer #1"})

          @game_ui.play()
        end

        it "writes ArgumentErrors from the game engine to the console" do
          @game_engine.should_receive(:play).and_raise(ArgumentError, "fake argument error")
          SetupPlayers(0, "")
          @terminal.should_receive(:say).at_least.once.with(/fake argument error/)
          @terminal.should_receive(:say)

          @game_ui.play()
        end
  
        it "prints score for every player and indicate winning player" do
          SetupPlayers(0, "")  
          tom = flexmock("player tom", :name=>"tom", :score=>3001)
          dick = flexmock("player dick", :name=>"dick", :score=>0)
          harry = flexmock("player harry", :name=>"harry", :score=>0) 
          ai1 = flexmock("player AI_1", :name=>"AI_1", :score=>0)       
          @game_engine.should_ignore_missing
          @game_engine.should_receive(:players).and_return([tom, dick, harry, ai1])
      
          @terminal.should_receive(:say).at_least.once.with(/tom.*3001.*WINNER.*dick.*0.*harry.*0.*AI_1.*0/m)
          @terminal.should_receive(:say)

          @game_ui.play()    
        end
      end
    end
  end
end


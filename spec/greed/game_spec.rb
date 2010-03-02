require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Greed  
  describe Game do 
    context "when playing the game with less than two players" do
      it "raises an argument error" do
        game = Game.new
        game_ui = flexmock("fake game ui")

        lambda { game.play(game_ui, nil) }.should raise_error(ArgumentError, /Two or more players/)
        lambda { game.play(game_ui, []) }.should raise_error(ArgumentError, /Two or more players/)
      end
    end

    context "when playing rounds 1...N of the game with three players tom, dick, and harry"  do
      before(:each) do
        @game_ui = flexmock("fake game ui")
        @game_ui.should_ignore_missing

        @tom = flexmock("player tom")
        @tom.should_receive(:score).and_return(0, 0, 0, 0, 3175)
        @dick = flexmock("player dick")
        @dick.should_receive(:score).and_return(0)
        @harry = flexmock("player harry")
        @harry.should_receive(:score).and_return(0)

        @players = [@tom, @dick, @harry]
        @game = Game.new
      end

      it "gives every player a turn to roll until a player has a winning score (>= 3000)" do
        @tom.should_receive(:play_turn).once.with(DiceSet).ordered(:turns)
        @dick.should_receive(:play_turn).twice.with(DiceSet).ordered(:turns)
        @harry.should_receive(:play_turn).twice.with(DiceSet).ordered(:turns)

        @game.play(@game_ui, @players)
      end
    end

    context "when playing the final round of the game with three players tom, dick, and harry" do
      before(:each) do
        @game_ui = flexmock("fake game ui")
        @game_ui.should_ignore_missing
    
        @tom = flexmock("player tom")
        @tom.should_receive(:score).and_return(3175)
        @tom.should_receive(:play_turn).never
        @dick = flexmock("player dick")
        @dick.should_receive(:score).and_return(0)
        @dick.should_receive(:play_turn).once.with(DiceSet).ordered(:turns)
        @harry = flexmock("player harry")
        @harry.should_receive(:score).and_return(0)
        @harry.should_receive(:play_turn).once.with(DiceSet).ordered(:turns)

        @players = [@tom, @dick, @harry]
        @game = Game.new
      end

      it "gives every player other than the leading player one more turn once a player has a winning score (>= 3000)" do
        @game.play(@game_ui, @players)
      end

      it "does not raise error when game ui does not respond to :entering_final_round" do
        lambda {@game.play(@game_ui, @players)}.should_not raise_error(ArgumentError)
      end

      it "notifes game ui about :entering_final_round with leading player"  do
        @game_ui.should_receive(:entering_final_round).with(@tom)

        @game.play(@game_ui, @players)
      end
    end
  end
end
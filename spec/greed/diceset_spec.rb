require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Greed
  describe DiceSet do
    context "when first created with N dice" do
      it "has N dice left to roll" do
        @dice = DiceSet.new(5)
        @dice.left_to_roll.should eql(5)
      end
    
      it "has a score of zero" do
        @dice = DiceSet.new(5)
        @dice.score.should eql(0)
      end
    
      it "should have no values" do
        @dice = DiceSet.new(5)
        @dice.values.should eql([])
      end
    end

    context "when rolling N dice" do
      before(:each) do
        @dice = DiceSet.new(5)
      end

      it "values are a set of N integers between 1 and 6" do
        @dice.roll()
        @dice.values.should be_a(Array)
        @dice.values.should have(5).items
        @dice.values.each do |value|
          true.should eql(value >=1 && value <=6)
        end
      end

      it "does not change values unless rolled" do
        @dice.roll()
        first_time = @dice.values
        second_time = @dice.values
        first_time.should eql(second_time)
      end

      it "changes values when dice are rolled"  do
        @dice.roll()
        first_time = @dice.values

        @dice.roll()
        second_time = @dice.values

        first_time.should_not eql(second_time)
      end
    
      it "does not change dice left to roll unless rolled" do
        @dice.roll()
        first_time = @dice.left_to_roll
        second_time = @dice.left_to_roll
        first_time.should eql(second_time)            
      end
    
      it "dice left to roll and score becomes zero for a roll of zero score" do
        @dice.instance_eval do
           @score = 50
         end
        @dice.score.should eql(50)
        @dice = flexmock(@dice, :calculate_score=>[0,5])
        @dice.roll()    
        @dice.score.should eql(0)      
        @dice.left_to_roll.should eql(0)
      end
    
      it "does not change score unless rolled" do
        @dice.roll()
        first_time = @dice.score
        second_time = @dice.score
        first_time.should eql(second_time)
      end
    end
  
    context "when calculating score" do 
      before(:each) do
        @dice = DiceSet.new(0)
      end
    
      it "has zero score and zero non-scoring dice for empty roll" do
        @dice.calculate_score([]).should eql([0,0])
      end

      it "has a score of 50 and zero non-scoring dice for a roll of a single 5" do
        @dice.calculate_score([5]).should eql([50,0])
      end

      it "has a score of 100 and zero non-scoring dice for a roll of a single 1" do
        @dice.calculate_score([1]).should eql([100,0])
      end

      it "has a score of the sum of 1*n*100 + 5*n*50 and zero non-scoring dice for a roll of 1s and 5s" do
        @dice.calculate_score([1,5,5,1]).should eql([300,0])
      end

      it "has a score of zero and four non-scoring dice for a roll of 2s,3s,4s, and 6s" do
        @dice.calculate_score([2,4,4,6]).should eql([0,4])
      end

      it "has a score of 1000 and zero non-scoring dice for a roll of triple 1s" do
        @dice.calculate_score([1,1,1]).should eql([1000,0])
      end

      it "has a score of 100*digit and zero non-scoring dice for a roll of triple 2s, 3s, 4s, 5s, and 6s" do
        @dice.calculate_score([2,2,2]).should eql([200,0])
        @dice.calculate_score([3,3,3]).should eql([300,0])
        @dice.calculate_score([4,4,4]).should eql([400,0])
        @dice.calculate_score([5,5,5]).should eql([500,0])
        @dice.calculate_score([6,6,6]).should eql([600,0])
      end

      it "has a score of the mixed sum and zero non-scoring dice for a roll of all scoring dice" do
        @dice.calculate_score([2,2,2,5,5]).should eql([300,0])
        @dice.calculate_score([5,5,5,5]).should eql([550, 0])
      end

      it "has a score of the mixed sum and N non-scoring dice for a roll with N non-scoring dice" do
        @dice.calculate_score([2,3,4,5,5]).should eql([100,3])
        @dice.calculate_score([5,5,5,6,4]).should eql([500,2])
      end
     end
  end
end
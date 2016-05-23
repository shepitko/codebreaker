require 'spec_helper'
require 'stringio'

module Codebreaker
  describe Cli do
    let(:cli){ Cli.new }
    describe "#intialize" do
      it 'When "start game", should see "Welcome to Codebreaker!"' do 
        expect { cli }.to output('Welcome to Codebreaker!').to_stdout 
      end 
    end

    describe "#choice_mode" do
      it "after should choiced mode" do
        expect { cli.change_mode }.to output('/1.Easy/+/2.Normal/+/3.Hard/').to_stdout
        expect { cli.change_mode }.to output('/Make your choice:/').to_stdout 
      end
      context "if choice"
        it "easy mode" do
          expect { cli.change_mode }.to output('/You have 20 attempts/').to_stdout 
        end
        it "normal mode" do
          expect { cli.change_mode }.to output('/You have 10 attempts/').to_stdout 
        end
        it "hard mode" do
          expect { cli.change_mode }.to output('/You have 5 attempts/').to_stdout 
        end
      end
    end

    describe "#attempt" do
      it 'should see "Enter guess:"' do
        expect { cli.check_attempt }.to output('/Enter guess:/').to_stdout
      end
      it "when win game" do
        #enter win code
      end

      it "when lose game" do
        #enter lose code
      end

      it "when enter code(combination)" do
        #enter whatever code and !lose and !win, recieve self.attempt
      end
    end


    describe "#check_result" do
      it "when 'game win'" do
        expect { cli.check_result(:win) }.to output('/Do you want play yet?/').to_stdout
      end
      it "when 'game lose'" do
        expect { cli.check_result(:lose) }.to output('/Do you want play yet?/').to_stdout
      end
    end

    
  end
end
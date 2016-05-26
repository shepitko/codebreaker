require 'spec_helper'
require 'stringio'

module Codebreaker
  describe Cli do

    describe "#intialize" do
      it 'When "start game", should see "Welcome to Codebreaker!"' do 
        expect { subject }.to output("Welcome to Codebreaker!\n").to_stdout 
      end 
    end
    
    describe "#choice_mode" do
    
      it "output the list of modes" do
        $stdin = StringIO.new(['1','2','3'].sample)
        expect { subject.choice_mode }.to \
        output(Regexp.union(['Easy', 'Normal', 'Hard', 'Make your choice:'])).to_stdout
        $stdin = STDIN
      end
      
      shared_examples "difficulty levels" do |h|
        it "#{h[:mode]} mode" do
          $stdin = StringIO.new("#{h[:input_num]}") 
          expect { subject.choice_mode }.to \
          output(Regexp.union(["You have #{h[:attempts]} attempts"])).to_stdout
          $stdin = STDIN
        end
      end
      
      context "print the number of attempts" do

        include_examples "difficulty levels", {mode:'easy', input_num:'1', attempts:"20"}
        include_examples "difficulty levels", {mode:'normal', input_num:'2', attempts:"10"}
        include_examples "difficulty levels", {mode:'hard', input_num:'3', attempts:"5"}
        
        it "invalid mode" do
          $stdin = StringIO.new(('a'..'z').to_a.sample) 
            expect { subject.choice_mode }.to \
            output(Regexp.union(["invalid input"])).to_stdout
          $stdin = STDIN
        end
      end
    end

    describe "#attempt" do
      it 'should show "Enter guess:"' do
        $stdin = StringIO.new("1234") 
        expect { subject.attempt }.to output(Regexp.union(["Enter guess:"])).to_stdout
        $stdin = STDIN
      end
    end

    describe "#check_result" do
      it "when 'game win'" do
        expect { subject.check_result(:win) }.to output(Regexp.union(["You win!"])).to_stdout
      end
      it "when 'game lose'" do
        expect { subject.check_result(:lose) }.to output(Regexp.union(["LOSER!!!"])).to_stdout
      end
    end

    describe "#try_again" do
      let(:try_again){ subject.try_again }
      let(:regexp){ Regexp.union(["Do You Want To Play More?(y/n)"]) }

      it 'option "y" or "yes"' do
        $stdin = StringIO.new("y") 
        expect { try_again }.to output(regexp).to_stdout
        $stdin = STDIN
      end
      it 'option "n" or "no" or "whatever"' do
        $stdin = StringIO.new("n") 
        expect { try_again }.to output(regexp).to_stdout
        $stdin = STDIN
      end
    end

  end
end
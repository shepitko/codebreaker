require 'spec_helper'
require 'stringio'

module Codebreaker
  describe Cli do
    let(:cli){ Cli.new }
    describe "#intialize" do
      it 'When "start game", should see "Welcome to Codebreaker!"' do 
        expect { cli }.to output("Welcome to Codebreaker!\n").to_stdout 
      end 
    end
    
    describe "#choice_mode" do
    
      it "output the list of modes" do
        $stdin = StringIO.new(['1','2','3'].sample)
        expect { cli.choice_mode }.to \
        output(Regexp.union(['Easy', 'Normal', 'Hard', 'Make your choice:'])).to_stdout
        $stdin = STDIN
      end
      
      RSpec.shared_examples "choise mode" do |h|
       it "#{h[:mode]} mode" do
          $stdin = StringIO.new("#{h[:input_num]}") 
          unless h[:input_num].to_i.to_s == '0'
            expect { cli.choice_mode }.to \
            output(Regexp.union(["You have #{h[:attempts]} attempts"])).to_stdout
          else
            expect { cli.choice_mode }.to \
            output(Regexp.union(["invalid input"])).to_stdout
          end 
          $stdin = STDIN
        end
      end
      
      include_examples "choise mode", {mode:'easy', input_num:'1', attempts:"20"}
      include_examples "choise mode", {mode:'normal', input_num:'2', attempts:"10"}
      include_examples "choise mode", {mode:'hard', input_num:'3', attempts:"5"}
      include_examples "choise mode", {mode:'invalid', input_num:('a'..'z').to_a.sample, attempts:""}
      
    end

    describe "#attempt" do
      it 'should show "Enter guess:"' do
        $stdin = StringIO.new("1234") 
        expect { cli.attempt }.to output(Regexp.union(["Enter guess:"])).to_stdout
        $stdin = STDIN
      end
    end


    describe "#check_result" do
      it "when 'game win'" do
        expect { cli.check_result(:win) }.to output("/You win!/").to_stdout
      end
      it "when 'game lose'" do
        expect { cli.check_result(:lose) }.to output('/LOSER!!!/').to_stdout
      end
    end
  end
end
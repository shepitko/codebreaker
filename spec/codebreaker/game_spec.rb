require 'spec_helper'
require 'date'
require 'yaml'

module Codebreaker
  describe Game do

    before do 
      subject.start
      subject.instance_variable_set(:@secret_code, "1623")
    end

    describe "#start" do
      it "saves secret code" do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it "saves 4 numbers secret code" do
        expect(subject.instance_variable_get(:@secret_code).size).to eq(4)
      end
      it "saves secret code with numbers from 1 to 6" do
        expect(subject.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
    end

    describe "#attempt" do
      it "input is not valid" do
        expect(subject.attempt("1sd ")).to eq('input not valid')
      end

      context "all options return value" do

        RSpec.shared_examples "checking the result" do |combinations|
          combinations.each do |arr|
            it "#{arr[0]}" do 
              expect(subject.attempt(arr[1])).to eq(arr[2])
            end
          end
        end

        context "guessed" do
          include_examples "checking the result", \
          [['one number', '1445', '+'],['two numbers', '1453', '++'],['three numbers', '1423', '+++'],['all numbers', '1623', :win]]
        end

        context "is not on its place" do
          include_examples "checking the result", \
          [['one number', '5141', '-'],['two numbers', '5131', '--'],['three numbers', '5236', '---'],['four numbers', '2361', '----']]
        end

        context "mixed result" do
          include_examples "checking the result", \
          [['2 guessed and 2 almost', '1632', '++--'],['1 guessed and 1 almost', '1244', '+-'],
          ['1 guessed and 2 almost', '6233', '+--'],['1 guessed and 3 almost', '1362', '+---']]
        end
      end

      context "return :lose after used all attempts" do
        [[:easy, 20], [:normal, 10], [:hard, 5]].each do |arr|
          it "#{arr[0]} mode - #{arr[1]} attemps" do
            subject.mode = arr[0]
            (arr[1] - 1).times{ subject.attempt("1928") }
            expect(subject.attempt("1928")).to eq(:lose)
          end
        end
      end

    end
    
    describe "#hint" do
      it "length eq 1" do
        expect(subject.hint.size).to eq(1)
      end
      it "contains one number of secret code" do
        expect(subject.instance_variable_get(:@secret_code)).to include(subject.hint)
      end
    end
    
    describe "#play_again" do
      it "will have created the new game if game win" do
        subject.attempt("1623")
        expect { subject.play_again }.to change{ subject.state }.from(:win).to(:new_game)
        expect(subject.cnt).to eq(0)
      end
      it "will have created the new game if game lose" do
        20.times{ subject.attempt("1928") }
        expect { subject.play_again }.to change{ subject.state }.from(:lose).to(:new_game)
        expect(subject.cnt).to eq(0)
      end
    end
    
    describe "save score" do
      it "after end game" do
        @buffer = StringIO.new()
        @filename = "results.yaml"
        @content = {name:"Test User", cnt:4, hint:true, date:DateTime.new}
        allow(File).to receive(:open).with(@filename,'w').and_yield( @buffer )

        File.open(@filename, 'w') {|f| f.write(@content)}
        expect(@buffer.string).to eq(@content.to_s)
      end
    end
  end
end
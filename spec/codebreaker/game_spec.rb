require 'spec_helper'
require 'date'
require 'yaml'

module Codebreaker
  describe Game do
    let(:game) { Game.new }

    describe "#start" do
      before do
        game.start
      end
      it "saves secret code" do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it "saves 4 numbers secret code" do
        expect(game.instance_variable_get(:@secret_code).size).to eq(4)
      end
      it "saves secret code with numbers from 1 to 6" do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
    end

    describe "#attempt" do
      before do 
        game.start
        game.instance_variable_set(:@secret_code, "1623")
      end
      it "input is not valid" do
        expect(game.attempt("1sd ")).to eq('input not valid')
      end
      context "checking the result" do
        
        context "guessed" do
          it "one number" do 
            expect(game.attempt("1445")).to eq('+')
          end
          it "two numbers" do 
            expect(game.attempt("1453")).to eq('++')
          end
          it "three numbers" do 
            expect(game.attempt("1423")).to eq('+++')
          end
          it "all numbers" do 
            expect(game.attempt("1623")).to eq(:win)
          end
        end
        context "is not in its place" do
          it "one number" do 
            expect(game.attempt("5141")).to eq('-')
          end

          it "two numbers" do 
            expect(game.attempt("5131")).to eq('--')
          end

          it "three numbers" do 
            expect(game.attempt("5236")).to eq('---')
          end

          it "four numbers" do 
            expect(game.attempt("2361")).to eq('----')
          end
        end
      end

      context "return :lose after used everything attempts" do
        before do 
          game.start
          game.instance_variable_set(:@secret_code, "1623")
        end
        it "easy mode - 20 attemps" do
          game.mode = :easy
          19.times{ game.attempt("1928") }
          expect(game.attempt("1928")).to eq(:lose)
        end
        it "normal mode - 10 attemps" do
          game.mode = :normal
          9.times{ game.attempt("1928") }
          expect(game.attempt("1928")).to eq(:lose)
        end
        it "hard mode - 5 attemps" do
          game.mode = :hard
          4.times{game.attempt("1928") }
          expect(game.attempt("1928")).to eq(:lose)
        end
      end
    end
    
    describe "#hint" do
      before do 
          game.start
      end
      it "length eq 1" do
        expect(game.hint.size).to eq(1)
      end
      it "contains one number of secret code" do
        expect(game.instance_variable_get(:@secret_code)).to include(game.hint)
      end
    end
    
    describe "#play_again" do
      before do 
          game.start
          game.instance_variable_set(:@secret_code, "1623")
      end
    
      it "will have created the new game if game win" do
        game.attempt("1623")
        expect { game.play_again }.to change{ game.state }.from(:win).to(:new_game)
        expect(game.cnt).to eq(0)
      end
      
      it "will have created the new game if game lose" do
        20.times{ game.attempt("1928") }
        expect { game.play_again }.to change{ game.state }.from(:lose).to(:new_game)
        expect(game.cnt).to eq(0)
      end
      #if end game, then have to offer new game
    end
    
    describe "save score" do
      it "after end game" do
        @buffer = StringIO.new()
        @filename = "results.yaml"
        @content = Hash.new
        @content['name'] = "Test User"
        @content['cnt'] = 4
        @content['hint'] = true
        @content['date'] = DateTime.new
        allow(File).to receive(:open).with(@filename,'w').and_yield( @buffer )

        File.open(@filename, 'w') {|f| f.write(@content)}

        expect(@buffer.string).to eq(@content.to_s)
      end
    end

  end
end
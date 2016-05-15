require 'spec_helper'
 
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
      it "checking instance variables" do
        expect(game.cnt).to eq(0)
        expect(game.hint).to eq(0)
        expect(game.date).to eq(Date.new)
        expect(game.name).to eq('anonimus')
      end
    end

    describe "#attempt" do
      context "checking the result" do
        before do 
          game.instance_variable_set(:@secret_code, "1623")
        end
        context "guessed" do
          it "one number" do 
            expect(game.attemp("1442")).to eq('+')
          end
          it "two numbers" do 
            expect(game.attemp("1453")).to eq('++')
          end
          it "three numbers" do 
            expect(game.attemp("1643")).to eq('++++')
          end
          it "all numbers" do 
            expect(game.attemp("1623")).to eq('You win!!!')
          end
        end
        context "is not in its place" do
          it "one number" do 
            expect(game.attemp("5141")).to eq('-')
          end

          it "two numbers" do 
            expect(game.attemp("5131")).to eq('--')
          end

          it "three numbers" do 
            expect(game.attemp("5236")).to eq('---')
          end

          it "four numbers" do 
            expect(game.attemp("2361")).to eq('----')
          end
        end
      end
      it "then used three attempts, counter increse by 3" do
        game.start
        expect { 3.times { game.attempt('7286') } }.to change(game.cnt, 0).from(0).to(2)
      end

      context "return 'game over' after used everything attempts" do
        it "easy mode - 20 attemps" do
          game.mode(:easy)
          expect(20.times{ game.attemp("1928")}).to eq('game over')
        end
        it "normal mode - 10 attemps" do
          game.mode(:normal)
          expect(10.times{ game.attemp("1928")}).to eq('game over')
        end
        it "hard mode - 5 attemps" do
          game.mode(:hard)
          expect(5.times{ game.attemp("1928")}).to eq('game over')
        end
      end
    end
    describe "plays again" do
      it "mock"
      #if end game, then have to offer new game
    end
    describe "request hint" do
      it "length eq 1" do
        expect(game.hint.size).to eq(1)
      end
      it "contains one number from a secret code" do
        expect(game.instance_variable_get(:@secret_code)).to include(game.hint)
      end
    end
    describe "save score" do
      it "save score after end game" 
    end


  end
end

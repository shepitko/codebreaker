module Codebreaker
require_relative 'game'
  class Cli
    def initialize(game = Game.new)
      print "Welcome to Codebreaker!\n"
      @game = game
      @game.start
    end
    
    def choice_mode
      print "1.Easy\n2.Normal\n3.Hard\n"
      print "Make your choice:\n"
      mode = gets.chomp
      case mode
      when '1' 
        @game.mode = :easy
        print "You have 20 attempts\n" 
      when '2' 
        @game.mode = :normal
        print "You have 10 attempts\n" 
      when '3' 
        @game.mode = :hard
        print "You have 5 attempts\n" 
      else
        print "invalid input,\n the default mode is selected(Normal- 10 attempts)\n" 
      end
    end
    
    def use_hint
      print "Do you want use hint?(y/n)"
      answer = gets.chomp
      print "Hint:"+@game.hint+"\n" if answer[0].downcase == 'y'
    end
    
     def attempt
      print "Enter guess:"
      guess = gets.chomp
      @game.attempt(guess)
    end
    
    def check_result(guess)
      case guess 
      when :win
        print "You win!"
      when :lose  
        print "LOSER!!!\n"
      else 
        print guess+"\n"
      end
    end

    def save_score
      print "Prompt your name:" 
      name = gets.chomp
      @game.save_score(name)
    end
    
    def try_again
      print "Do You Want To Play More?(y/n)"
      answer = gets.chomp
      if answer[0].downcase == 'y' 
        @game.play_again
      else
        print "Goodbye!\n"
      end
    end
  end
end

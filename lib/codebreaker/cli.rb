

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
      print "Do yo want use hint?(y/n)"
      answer = gets.chomp
      @game.hint+"\n" if answer[0].downcase == 'y'
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
        save_score
      when :lose  
        print "LOSER!!!\n"
        try_again
      else 
        print guess+"\n"
        attempt
      end
    end
    
    def save_score
      print "Prompt your name:" 
      name = gets.chomp
      @game.save_score(name)
      try_again
    end
    
    def try_again
      print "Do You Want To Play More?(y/n)"
      answer = gets.chomp
      if answer[0].downcase == 'y' 
        initialize
        choice_mode
        attempt
      else
        print "Goodbye!\n"
      end
    end
  end
end

#cli = Codebreaker::Cli.new
#cli.use_hint
#cli.choice_mode
#check_result(cli.attempt)
require 'date'
require 'yaml'
module Codebreaker
  class Game

    attr_accessor :date, :name
    attr_reader :cnt, :state

    MODES = {easy: 20, normal: 10, hard: 5 }
    
    def initialize
      @secret_code = ""
    end

    def start
      @secret_code = (1..4).map{ rand(1..6) }.join
      @state = :new_game
      @cnt = 0
      @mode = MODES[:normal] 
    end

    def attempt(num)
      return "input not valid" unless num !~ /\D/
      @cnt += 1
      
      case
      when num == @secret_code
        @state = :win
      when (@cnt >= @mode) && (@secret_code != num) 
        @state = :lose
      else 
        check(num)
      end
    end

    def mode=(sym)
      @mode = MODES[sym]
    end
    
    def check(num)
      code = @secret_code.chars
      num = num.chars
      mark = code.zip(num).delete_if{|v| v[0] == v[1]} 
      plus = '+' * (4 - mark.length)
      minus = '-' * (mark.transpose[0] & mark.transpose[1]).length
      result = plus << minus
    end
    
    def hint
      @hint = true
      @secret_code.split("").sample
    end
    
    def play_again
      start
    end
    
    def save_score(username = 'undefined')
      scores = YAML::load_file('score.yml')
      content = { username:username, cnt:@cnt , hint:@hint || false, date:DateTime.new}
      if scores
        scores[:scores] << content
      else
        scores = { scores: [content] }
      end
      File.open('score.yml', 'w') { |f| f.write scores.to_yaml }
    end

    def show_score
      YAML::load_file('score.yml')
    end
    
  end
end
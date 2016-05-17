require 'date'
module Codebreaker
  class Game


    attr_accessor :cnt, :date, :name
    def initialize
      @secret_code = ""
      @modes = {easy: 20, normal: 10, hard: 5 }
    end
 
    def start
      4.times{ @secret_code += rand(1..6).to_s }
      @date = DateTime.now
      @name = "anonimus"
      @cnt = 0
      @mode = @modes[:easy] #default value
    end

    def attempt(num)      
      @cnt += 1
      
      case
      when num == @secret_code then "You win!!!"
      when @cnt == @mode && @secret_code =! num then "game over"
      
      end
    end

    def mode=(sym)
      @mode = @modes[sym]
    end
  end
end

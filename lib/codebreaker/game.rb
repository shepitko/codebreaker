require 'date'

class Codebreaker::Game

  attr_accessor :date, :name
  attr_reader :cnt, :state
  
  def initialize
    @secret_code = ""
    @modes = {easy: 20, normal: 10, hard: 5 }
  end

  def start
    4.times{ @secret_code += rand(1..6).to_s }
    #default values
    @state = :new_game
    @cnt = 0
    @mode = @modes[:easy] 
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
    @mode = @modes[sym]
  end
  
  def check(num)
    result = ""
    code = @secret_code.split("").map(&:to_i)
    num = num.split("").map(&:to_i)
    num.each_with_index do |v,k| 
      if v == code[k]
        result += "+"
        code[k] = nil
        num[k] = nil
      end
    end
    code.compact.each{|v| result += "-" if num.include?(v)}
    result
  end
  
  def hint
    @secret_code.split("").sample
  end
  
  def play_again
    start
  end
  
  def save_score(name)
    YAML::load_file('/tmp/test.yml')
    @content['name'] = "Test User"
    @content['cnt'] = 4
    @content['hint'] = true
    @content['date'] = DateTime.new
  end
  
end
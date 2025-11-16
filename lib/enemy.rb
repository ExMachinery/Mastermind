# Объект противник: Роль: Угадывающий/Загадывающий, Генерация и хранение кода.
 
class Enemy
  attr_accessor :role, :prng, :code

  def initialize
    self.prng = Random.new
    @past_true = 0
    @hint_sum_previous = 0
    @background = 0
    @work_array = [nil, nil, nil, nil]
    @pending_attempt = []
    @locked = [nil, nil, nil, nil]
    @alpha = false
    @betta = false
    @full = false
    @deep_think = false
  end

  def generate_code
    self.code = 0
    until code.to_s.match?(/^\d{4}$/)
      self.code = prng.rand(10000)
    end
    puts "Code generated."
  end

  def think_engine(player_code)
    # Here is a code, if player = thinker. Returns false, if couldn't pick code/ True, if success.
    puts "Enemy think engine started."
    round_counter = 0
    code_picked = nil
    hint = [nil]
    until round_counter == 20 || code_picked
      round_counter += 1
      attempt = process_attempt(hint)
      hint = break_attempt(player_code, attempt)
      if hint.count(true) == 4
        code_picked = true
      end
    end
    default_my_variables
    code_picked
  end

  def default_my_variables
    @past_true = 0
    @hint_sum_previous = 0
    @background = 0
    @work_array = [nil, nil, nil, nil]
    @pending_attempt = []
    @full = false
    @locked = [nil, nil, nil, nil]
    @alpha = false
    @betta = false
    @deep_think = false
  end

  def process_attempt(hint)
    hint_sum = hint.count(true) + hint.count(false)
    direct_hit = nil
    if hint_sum == 4 && @full == false
      @full = true
      complite_array = []
      @work_array.each_with_index do |num, ind|
        if num == nil
          complite_array << @background - 1
          direct_hit = ind
        else
          complite_array << num
        end
      end
      @work_array = complite_array.dup
      @pending_attempt = complite_array.dup
      if hint.count(true) > @past_true
        @locked[direct_hit] = true
      end
      @past_true = hint.count(true)
    end

    if (hint.count(true) < @past_true) && @full == false
      (@past_true - hint.count(true)).times do
        swapper!(@work_array)
      end 
    end

    if (hint_sum == @hint_sum_previous) && hint.count(false) > 0 && @full == false && (hint.count(true) >= @past_true)
      swapper!(@work_array)
    end

    if (hint_sum > @hint_sum_previous) && @full == false
      counter = hint_sum - @hint_sum_previous
      proxy_arr = []
      @work_array.each do |num|
        if counter != 0 && num == nil
          proxy_arr << @background - 1
          counter -= 1
        else
          proxy_arr << num
        end
      end
      @work_array = proxy_arr
    end

    attempt = []
    if @full == false
      @work_array.each do |num|
        if num == nil
          attempt << @background
        else
          attempt << num
        end
      end
    elsif @full
      if !@deep_think
        attempt = @work_array.dup
        index_carrier
        attempt[@alpha], attempt[@betta] = attempt[@betta], attempt[@alpha]
        @deep_think = true
      else
        attempt = new_logic(hint)
      end
    end

    if !@full
      @background += 1
      @hint_sum_previous = hint_sum
      @past_true = hint.count(true)
    end
    puts "Maybe this: #{attempt.join}?"
    if @full == true
      @pending_attempt = attempt.dup
    end
    attempt.map! { |x| x.to_s}
    attempt

  end

  # Swaps first non-nil element with nil on the right (if such nil exsist)
  def swapper!(array)
    swap = (0...(array.size - 1)).find { |index| !array[index].nil? && array[index + 1].nil? }
    if swap
      array[swap], array[swap+1] = array[swap+1], array[swap]
    end
  end
    
  # def switcher!(array)
  #   array[@switched_element], array[@switched_element + @for_switch] = array[@switched_element + @for_switch], array[@switched_element]
  # end
    
  def break_attempt(player_code, attempt)
    hint = []
    player_code.each_with_index do |code_num, code_index|
      if attempt.include?(code_num)
        if code_num == attempt[code_index]
          hint << true
        else
          hint << false
        end
      else
        hint << nil
      end
    end
    puts "Yes: #{hint.count(true)}, Almost: #{hint.count(false)}"
    puts "======================================="
    hint
  end

  def new_logic(hint)
    puts "======================================="
    attempt = []
    skip = false
    if @past_true >= hint.count(true)
      puts "NEW_LOGIC. T.p >= T.c, hint: #{hint}"
      if @past_true - hint.count(true) == 2 && @alpha && @betta
        @locked[@alpha], @locked[@betta] = true, true
        skip = true
      end
      attempt = @work_array.dup
      if !@locked.include?(false) && !skip
        @locked[@alpha] = 0
        @locked[@betta] = false
      elsif @locked.include?(false) && !skip
        @locked[@betta] = 0
      end
      puts "Current locked: #{@locked}"
      index_carrier
    elsif @past_true < hint.count(true)
      puts "NEW_LOGIC. T.p < T.c, hint: #{hint}"
      @work_array = @pending_attempt.dup
      attempt = @work_array.dup
      @locked[@betta] = true
      @locked[@alpha] = false
      @locked.each_with_index do |val, ind|
        if val == 0
          @locked[ind] = nil
        end
      end
      puts "Current locked: #{@locked}"
      index_carrier
      @past_true = hint.count(true)
    else
      puts "Вариант равенства существует!!!!"
    end
    attempt[@alpha], attempt[@betta] = attempt[@betta], attempt[@alpha]
    puts "Send attempt: #{@work_array} => #{attempt}"
    attempt
  end

  def index_carrier
    puts "INDEX CARRIER. #{@locked}"
    @alpha, @betta = false, false
    if !@locked.include?(nil)
      @locked.each_with_index do |val, ind|
        if val == 0 || val == false
          @locked[ind] = nil
        end
      end
      i = @locked.find_index {|val| val == nil }
      @locked[i] = false
    end

    if @locked.include?(false)
      @locked.each_with_index do |val, ind|
        if val == false
          @alpha = ind
        elsif val == nil && !@betta
          @betta = ind
        end
      end
    else
      @locked.each_with_index do |val, ind|
        if val == nil && !@alpha
          @alpha = ind
        elsif val == nil || val == 0 && !@betta
          @betta = ind
        end
      end
    end
    puts "INDEX CARRIER. #{@alpha}, #{@betta}"
  end
end


  # def new_logic(hint)
  #   puts "======================================="
  #   attempt = []
  #   skip = false
  #   if @past_true = hint.count(true)
  #     puts "NEW_LOGIC. T.p >= T.c, hint: #{hint}"
  #     if @past_true - hint.count(true) == 2 && @alpha && @betta
  #       @locked[@alpha], @locked[@betta] = true, true
  #       skip = true
  #     end  
  #     attempt = @work_array.dup
  #     @locked[@betta] = 0 if !skip && @betta
  #     puts "Current locked: #{@locked}"
  #     index_carrier
  #   elsif @past_true < hint.count(true)
  #     puts "NEW_LOGIC. T.p < T.c, hint: #{hint}"
  #     @locked.each_with_index do |value, ind|
  #       if value == 0
  #         @locked[ind] = nil
  #       end
  #     end

  #     if hint.count(true) - @past_true == 2 && @alpha && @betta
  #       @locked[@alpha], @locked[@betta] = true, true
  #     else
  #       @locked[@betta] = false
  #     end
  #     @work_array = @pending_attempt.dup
  #     attempt = @work_array.dup
  #     puts "Current locked: #{@locked}"
  #     index_carrier
  #   end
  #   attempt[@alpha], attempt[@betta] = attempt[@betta], attempt[@alpha]
  #   puts "Send attempt: #{@work_array} => #{attempt}"
  #   attempt
  # end
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
    @locked = [false, nil, nil, nil]
    @alpha = false
    @betta = false
    @deep_think = false
  end

  def process_attempt(hint)
    hint_sum = hint.count(true) + hint.count(false)
    if hint_sum == 4 && @full == false
      @full = true
      complite_array = []
      @work_array.each_with_index do |num, ind|
        if num == nil
          complite_array << @background - 1
        else
          complite_array << num
        end
      end
      @work_array = complite_array.dup
      @scenario = hint.count(true)
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
        attempt = new_logic(hint)
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

  @scenario = nil
  @deep_think_step = 0
  @possible1 = []
  @possible2 = []
  @next_possibilitie = false
  @next_try = false
  def new_logic(hint)
    attempt = @work_array
    if @scenario == 0
      puts "####== SCENARIO_0 ==####"
        if @deep_think_step == 0
          index_carrier(nil, nil)
          @deep_think_step += 1
        elsif @deep_think_step == 1 && hint.count(true) == 2 && @next_try == false # Solved
          @locked = [true, true, nil, nil]
          index_carrier(nil, nil)
        elsif @deep_think_step == 1 && hint.count(true) == 1 || @next_try == true
          @possible1 = [true, false, nil, nil]
          @possible2 = [false, true, nil, nil]
          if !@next_try
            @locked = @possible1.dup
          else
            @locked = @possible2.dup
            @next_possibilitie = false
          end
          index_carrier(false, nil)
          @deep_think_step += 1
        elsif (@deep_think_step == 2 && hint.count(true) == 2) || @next_possibilitie == true
          if !@next_try
            @possible1 = [true, true, nil, nil]
            @possible2 = [true, nil, true, nil]
          else
            @possible1 = [true, true, nil, nil]
            @possible2 = [nil, true, true, nil]
          end
          if !@next_possibilitie
            @locked = @possible1.dup
            @next_possibilitie = true
          else
            @locked = @possible2.dup
          end
          index_carrier(nil, nil)
        elsif @deep_think_step == 2 && hint.count(true) < 2
          if !@next_try
            @locked = [true, nil, nil, true]
          else
            @locked = [nil, true, nil, true]
            puts "I'm fucking out of suggestions..."
          end
          index_carrier(nil, nil)
          @next_try = true
          @deep_think_step -= 1
        end
      attempt[@alpha], attempt[@betta] = attempt[@betta], attempt[@alpha]
      puts "####================####"
    elsif @scenario == 1
      puts "####== SCENARIO_1 ==####"
      # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      # HERE HERE HERE HERE HERE HERE
      # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      puts "####================####"
    elsif @scenario == 2
      puts "####== SCENARIO_2 ==####"
      if @deep_think_step < 3 && hint.count(true) > 0
        @alpha, @betta = false, false
        @locked.each_with_index do |val, ind|
          if val == nil && !@betta
            @locked[ind] = 0
            @betta = ind
          elsif val == false && !@alpha
            @alpha = ind
          end
        end
        @deep_think_step += 1
      elsif @deep_think_step < 3 && hint.count(true) == 0 # Solved
        @locked[@alpha], @locked[@betta] = true, true
        @alpha, @betta = false, false
        @locked.each_with_index do |val, ind|
          if val != true && !@alpha
            @alpha = ind
          elsif val != true && !@betta
            @betta = ind
          end
        end
      elsif @deep_think_step == 3 && hint.count(true) == 0 # Solved
        @locked = [true, nil, nil, true]
        index_carrier(nil, nil)
      end
      attempt[@alpha], attempt[@betta] = attempt[@betta], attempt[@alpha]
      puts "####================####"
    end
  end

  def index_carrier(a, b)
    puts "INDEX CARRIER. #{@locked}"
    @alpha, @betta = false, false
    @locked.each_with_index do |val, ind|
      if val == a && !@alpha
        @alpha = ind
      elsif val == b && !@betta
        @betta = ind
      end
    end
    puts "INDEX CARRIER. #{@alpha}, #{@betta}"
  end
end



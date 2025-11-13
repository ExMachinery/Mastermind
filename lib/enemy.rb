# Объект противник: Роль: Угадывающий/Загадывающий, Генерация и хранение кода.
 
class Enemy
  attr_accessor :role, :prng, :code

  def initialize
    self.prng = Random.new
    @hint_true_previous = 0
    @hint_sum_previous = 0
    @background = 0
    @work_array = [nil, nil, nil, nil]
    @pending_attempt = []
    @switched_element = 0
    @for_switch = 1
    @full = false
  end

  def generate_code
    self.code = 0
    until code.to_s.match?(/^\d{4}$/)
      self.code = prng.rand(10000)
    end
  end

  def think_engine(player_code)
    # Here is a code, if player = thinker. Should return 1 (AI win) or 2 (AI loose)
    # This is for debug.
    # @hint_true_previous = 0
    # @hint_sum_previous = 0
    @background = 0
    # @work_array = [nil, nil, nil, nil]
    # @pending_attempt = []
    # @switched_element = 0
    # @for_switch = 1
    # @full = false
    
    round_counter = 0
    code_picked = nil
    hint = [nil]
    until round_counter == 12 || code_picked
      round_counter += 1
      attempt = process_attempt(hint)
      hint = break_attempt(player_code, attempt)
      if hint.count(true) == 4
        code_picked = true
      end
    end
    code_picked
  end

  def process_attempt(hint)
    # p @work_array
    # p @pending_attempt
    hint_sum = hint.count(true) + hint.count(false)
    if hint_sum == 4
      puts "================================="
      @full = true
      @work_array = @pending_attempt
    end

    if (hint.count(true) < @hint_true_previous) && @full == false
      (@hint_true_previous - hint.count(true)).times do
        swapper!(@work_array)
      end 
    end

    if (hint_sum == @hint_sum_previous) && hint.count(false) > 0 && @full == false
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
      if @work_array[@switched_element + @for_switch] == nil
        @for_switch = 1
        @switched_element += 1
      end

      if hint.count(true) <= @hint_true_previous
        attempt = @work_array
        switcher!(attempt)
        @for_switch += 1
      elsif hint.count(true) > @hint_true_previous
        attempt = @pending_attempt
        @work_array = @pending_attempt
        @for_switch = 1
        @switched_element += 1
        switcher!(attempt)
      end
    end

    @background += 1
    @hint_sum_previous = hint_sum
    @hint_true_previous = hint.count(true)
    puts "Maybe this: #{attempt.join}?"
    @pending_attempt = attempt
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
    
  def switcher!(array)
    array[@switched_element], array[@switched_element + @for_switch] = array[@switched_element + @for_switch], array[@switched_element]
  end
    
  def break_attempt(player_code, attempt)
    hint = []
    player_code.each_with_index do |code_num, code_index|
      if attempt.include?(code_num)
        attempt.each_with_index do |attempt_num, attempt_index|
          if attempt_num == code_num && attempt_index == code_index
            hint << true
            attempt.fill(nil, attempt_index, 1)
            break
          elsif attempt_num == code_num && attempt_index != code_index
            hint << false
            attempt.fill(nil, attempt_index, 1)
            break
          end
        end
      else
        hint << nil
      end
    end
    hint
  end
end
  
  # 1. Собрать болванку @work_array в 4 nil
  # 2. Если hint_true < previous hint_true || (hint_sum == previous_hint_sum && hint.count(false)) )
  #     Сдвинуть last на [разницу количестве true] вправо.
  # 3. Если hint_sum > previous hint_sum
  #     Первые же nil заменить на background - 1 [разница] раз
  #     Сохранить @work_array
  # 4. Заменить все nil на background
  # 5. Увеличить background
  # 6. Если hint_sum = 4
  #     C.True = hint_true
  #     1 раз:
  #       Вписать в @Work_array Background - 1 вместо nil
  #       Сохранить новую @wrok_array
  #     y = 1, x = 1
  #     C.True = 0
  #     Если C.True =< P.True
  #       Поменять 1 (x) элемент с 1 (y) соседом.
  #       y += 1
  #     Если C.True > P.True
  #       @work_array = attempt
  #       x += 1
  #       y = 1
  #     Если @work_array[y] == nil
  #       y = 1
  #       x += 1
  #     
  # . Отправить Attempt
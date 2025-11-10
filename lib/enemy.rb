# Объект противник: Роль: Угадывающий/Загадывающий, Генерация и хранение кода.
 
class Enemy
  attr_accessor :role, :prng, :code

  def initialize
    self.prng = Random.new
    @hint_true_previous = 0
    @hint_sum_previous = 0
    @background = 0
    @work_array = [nil, nil, nil, nil]
  end

  def generate_code
    self.code = 0
    until code.to_s.match?(/^\d{4}$/)
      self.code = prng.rand(10000)
    end
  end

  def think_engine(player_code)
    # Here is a code, if player = thinker. Should return 1 (AI win) or 2 (AI loose)
    round_counter = 0
    code_picked = nil
    until round_counter == 12 || code_picked
      hint = nil
      attempt = process_attempt(hint)
      hint = break_attempt(player_code, attempt)

      end




    end
  end
end



def process_attempt(hint)
  hint_sum = hint.count(true) + hint.count(false)
  if hint.count(true) < @hint_true_previous 
    (hint.count(true) - @hint_true_previous).times do
      swapper!(@work_array)
    end 
  end

  if hint_sum == @hint_sum_previous && hint.count(false)
    swapper!(@work_array)
  end

  if hint_sum > @hint_sum_previous
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
  @work_array.each do |num|
    if num == nil
      attempt << background
    else
      attempt << num
    end
  end

  @background += 1
  @hint_sum_previous = hint_sum
  @hint_true_previous = hint.count(true)
  puts "Maybe this: #{attempt}?"
  attempt


# 1. Собрать болванку @work_array в 4 nil
# 2. Если hint_true < previous hint_true || (hint_sum == previous_hint_sum && hint.count(false)) )
#     Сдвинуть last на [разницу количестве true] вправо.
# 3. Если hint_sum > previous hint_sum
#     Первые же nil заменить на background - 1 [разница] раз
#     Сохранить @work_array
# 4. Заменить все nil на background
# 5. Увеличить background
# 6. Отправить Attempt

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

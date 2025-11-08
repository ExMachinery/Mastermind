# Объект противник: Роль: Угадывающий/Загадывающий, Генерация и хранение кода.
 
class Enemy
  attr_accessor :role, :prng, :code

  def initialize
    self.prng = Random.new
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
      attempt = process_attempt()
      hint = break_attempt(player_code, attempt)

      end




    end
  end
end

def process_attempt(hint)
  correct = 0
  close = 0
  background = 0
  free = 4
  attempt = []
  free.times {attempt << background}


  # Background повышается, когда есть true/false.
  # Число замороженного background - true + false
  # Новая комбинация freeze background times background + next background times rest
  # Попытка
  #   Если при повышении Background true + false вырос
  #     Увеличить Freeze background
  #   Если True снизился
  #     Сдвинуть крайни правый на 1 вправо. 
end

def break_attempt(player_code, attempt)
  hint = []
  player_code.each_with_index do |code_num, code_index|
    if attempt.include?(code_num)
      attempt.each_with_index do |attempt_num, attempt_index|
        if attempt_num == code_num && attempt_index == code_index
          hint << true
          attempt.fill(nil, guess_index, 1)
          break
        elsif attempt_num == code_num && attempt_index != code_index
          hint << false
          attempt.fill(nil, guess_index, 1)
          break
        end
      end
    else
      hint << nil
    end
  end
  hint
end
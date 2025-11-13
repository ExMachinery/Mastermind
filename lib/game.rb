# Объект игра: Приём кода игрока, операции сравнения, расчёт фидбэка, контроль хода и win/lose condition, оповещения, реплей, хранение общего счёта.
require_relative 'player'
require_relative 'enemy'

class Game
  attr_accessor :player, :enemy

  def initialize
    @turn_num = 0
    self.player = Player.new
    self.enemy = Enemy.new
  end

  def start_game
    # Rolepicker logic here (only guesser for now)
    puts "Hi, #{player.name}! Input '1' for Guessing, '2' for Thinking"
    valid = false
    until valid
      player_game_choice = gets.chomp
      if player_game_choice == "1"
        valid = true
        self.player.role = 0
        self.enemy.role = 1
        game_sequence
      elsif player_game_choice == "2"
        valid = true
        self.player.role = 1
        self.enemy.role = 0
        game_sequence
      else
        puts "Incorrect input! Input '1' for Guessing, '2' for Thinking"
      end
    end
  end
  
  def game_sequence
    round(player.role)
    one_more = true
    while one_more
      puts "Want to play another round? (Y/n)"
      user_another_round = gets.chomp
      if user_another_round == "n"
        puts "Good buy!"
        one_more = false
      elsif user_another_round == "Y"
        round(player.role)
      else
        puts "Incorrect input. Type 'Y' to play another round or 'n' to exit game."
      end
    end
  end

  def round(player_role)
    # Player-guesser logic
    round_counter = 0
    if player_role == 0
      result = false
      enemy.generate_code
      puts "You have to guess a 4 digit number. Good luck, bro!"
      code = enemy.code.to_s.split("")
      until result || (round_counter == 12) do
        round_counter += 1
        guess = human_guess?
        result = guess_engine(guess, code)
      end

      if result == false
        puts "Time's up! You loose! Have a luck next time!"
      else
        puts "YAHOOO! You did it, boyo!"
      end

    # Player-thinker logic  
    elsif player_role == 1
      player.player_think_of_code
      result = enemy.think_engine(player.code)

      if result == true
        puts "Haha! Got you!"
      else
        puts "I was close! But your code is too good!"
      end
    end
  end

  def guess_engine(guess, code)
    # Here is a code, if player = guesser
    hint = []
    code.each_with_index do |code_num, code_index|
      if guess.include?(code_num)
        guess.each_with_index do |guess_num, guess_index|
          if guess_num == code_num && guess_index == code_index
            hint << true
            guess.fill(nil, guess_index, 1)
            break
          elsif guess_num == code_num && guess_index != code_index
            hint << false
            guess.fill(nil, guess_index, 1)
            break
          end
        end
      else
        hint << nil
      end
    end
    if hint.count(true) == 4
      return true
    else
      puts "CORRECT: #{hint.count(true)} | So close: #{hint.count(false)}. Try again!"
      return false
    end
  end

  def human_guess?
    valid_guess = 0
    valid = false
    puts "Your guess?"
    until valid do
      unvalid_guess = gets.chomp
      if unvalid_guess.match?(/^\d{4}$/)
        valid_guess = unvalid_guess.split("")
        valid = true
      else
        puts "Incorrect input. Insert 4 digit number."
      end
    end
    valid_guess
  end
end
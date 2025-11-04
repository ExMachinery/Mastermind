# Объект игра: Приём кода игрока, операции сравнения, расчёт фидбэка, контроль хода и win/lose condition, оповещения, реплей, хранение общего счёта.
require_relative 'player'
require_relative 'enemy'

class Game
  attr_accessor :player

  def initialize
    # Something to initialize
    @turn_num = 0
    self.player = Player.new
  end

  def start_game
    # Rolepicker logic here (only guesser for now)
    puts "Hi, #{player.name}! For now we have only guessing game. Enjoy!"
    self.player.role = 0
    result = round(player.role)
  end

  def round(player_role)
    if player_role == 0
      enemy = Enemy.new(1)
      puts "You have to guess a 4 digit number. Good luck, bro!"
    end
  end

  def guess_engine
    # Here is a code, if player = guesser
  end

  def think_engine
    # Here is a code, if player = thinker
  end

  def human_guess?
    valid = false
    puts "Your guess?"
    while valid == false
      unvalid_guess = gets.chomp.to_i
      # Validation logic here. STOPS HERE!
    end
  end

end
# Объект игрок: Имя, Угадывание: личный счёт побед/поражений, Роль: Угадывающий/Загадывающий

class Player
  attr_accessor :name, :role, :current_code, :guesser_score

  def initialize
    self.guesser_score = {
      wins: 0,
      loses: 0
    }
    puts "What is your name?"
    self.name = gets.chomp
  end

  def alter_score(result)
    # Take result and write to @guesser_score here
  end

  def human_code?
    self.current_code
  end


end
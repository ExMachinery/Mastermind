# Объект игрок: Имя, Угадывание: личный счёт побед/поражений, Роль: Угадывающий/Загадывающий

class Player
  attr_accessor :name, :role, :guesser_score

  def initialize
    self.guesser_score = {
      wins: 0,
      loses: 0
    }
    puts "What is your name?"
    self.name = gets.chomp
    # Role picker logic here for Phase 2. 0 - guesser, 1 - thinker
    self.role = 0
  end

  def alter_score(result)
    # Take result and write to @guesser_score here
  end


end
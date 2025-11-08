# Объект игрок: Имя, Угадывание: личный счёт побед/поражений, Роль: Угадывающий/Загадывающий

class Player
  attr_accessor :name, :role, :code, :guesser_score

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

  def player_think_of_code
    valid = false
    puts "Think of 4 digit number. I'll try to guess!"
    until valid do
      unvalid_code = gets.chomp
      if unvalid_code.match?(/^\d{4}$/)
        self.code = unvalid_code.split("")
        valid = true
      else
        puts "Incorrect input. Insert 4 digit number."
      end
    end
  end


end
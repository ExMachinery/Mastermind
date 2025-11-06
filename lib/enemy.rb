# Объект противник: Роль: Угадывающий/Загадывающий, Генерация и хранение кода.
 
class Enemy
  attr_accessor :role, :prng, :code

  def initialize(role)
    self.role = role
    self.prng = Random.new
    if role == 1
      self.code = prng.rand(10000)
    end
  end

  # def code?
  #   code
  # end
end
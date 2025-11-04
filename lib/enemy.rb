# Объект противник: Роль: Угадывающий/Загадывающий, Генерация и хранение кода.
 
class Enemy
  attr_accessor :role, :prng
  @current_code = nil

  def initialize(role)
    @role = role
    @prng = Random.new
    if role == 1
      @currend_code = prng.rand(10000)
    end
  end

  def code?
    @current_code
  end
end
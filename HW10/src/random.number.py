import random

def guess_number():
    # Генерируем число
    secret_number = random.randint(1, 100)
    attempts = 5

    print("Угадайте число от 1 до 100. Есть 5 попыток")

    # Цикл
    for attempt in range(attempts):
        try:
            # Принимаем данные от пользователя
            guess = int(input(f"Попытка {attempt + 1}: Введите число: "))

            # Проверяем число на правильность
            if guess == secret_number:
                print("Вы угадали число!")
                return
            elif guess > secret_number:
                print("Высоко!")
            else:
                print("Низко!")
        except ValueError:
            print("Пожалуйста введите целое число")
    
    # При использовании всех попыток
    print(f"У вас закончились попытки. Правильное число было: {secret_number}.")

guess_number()

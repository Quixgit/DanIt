import random

def guess_number():
    # Генерируем число
    secret_number = random.randint(1, 100)
    attempts = 5

    print("Вгадай число від 1 до 100. У вас є 5 спроб!")

    # Цикл для 5 спроб
    for attempt in range(attempts):
        try:
            # Приймаємо введення від користувача
            guess = int(input(f"Спроба {attempt + 1}: Введіть ваше число: "))

            # Перевіряємо правильність числа
            if guess == secret_number:
                print("Вітаємо! Ви вгадали правильне число.")
                return
            elif guess > secret_number:
                print("Занадто високо!")
            else:
                print("Занадто низько!")
        except ValueError:
            print("Будь ласка, введіть ціле число.")
    
    # Якщо 5 спроб не вдалося вгадати
    print(f"Вибачте, у вас закінчилися спроби. Правильний номер був {secret_number}.")

# Запускаємо гру
guess_number()

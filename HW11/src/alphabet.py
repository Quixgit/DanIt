# Класс конструктор
class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang  
        self.letters = list(letters)  
    
    def print(self):
        ## Выводит на экран все буквы алфавита.
        print(''.join(self.letters))
        
    ## Возвращает количество букв в алфавите
    def letters_num(self):
        return len(self.letters)

## Наследование от класс Alphabet _
class EngAlphabet(Alphabet):
      ###Кол-во букв
    _letters_num = 26
    
    ## Вызывает конструктор родительского класса Alphabet
    def __init__(self):
        
        super().__init__('En', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')
    
    @staticmethod
    def is_en_letter(letter):
        
        return letter.upper() in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    
    ## Возвращает количество букв 
    def letters_num(self):
        return EngAlphabet._letters_num
    
    ## Пример текста на английском
    @staticmethod
    def example():
        return "Hi, it's the English alphabet."


if __name__ == "__main__":
    
    eng_alphabet = EngAlphabet()
    
    ###
    print("Alphabet letters:")
    eng_alphabet.print()
    ###
    print("\nNumber of letters in the alphabet:")
    print(eng_alphabet.letters_num())
    ###
    print("\nIs 'D' in the English alphabet?")
    print(eng_alphabet.is_en_letter('D'))
    ###
    print("\nIs 'Б' in the English alphabet?")
    print(eng_alphabet.is_en_letter('Б'))
    ###
    print("\nExample text in English:")
    print(eng_alphabet.example())

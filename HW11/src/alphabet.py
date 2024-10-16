# Alphabet class
class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang  
        self.letters = list(letters)  
    
    def print(self):
        """Print all the letters of the alphabet."""
        print(''.join(self.letters))
    
    def letters_num(self):
        """Return the number of letters in the alphabet."""
        return len(self.letters)


class EngAlphabet(Alphabet):
    
    _letters_num = 26
    
    def __init__(self):
        
        super().__init__('En', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')
    
    @staticmethod
    def is_en_letter(letter):
        """Check if a letter belongs to the English alphabet."""
        return letter.upper() in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    
    def letters_num(self):
        """Override the letters_num method to return the number of letters in English alphabet."""
        return EngAlphabet._letters_num
    
    @staticmethod
    def example():
        """Return an example text in English."""
        return "The quick brown fox jumps over the lazy dog."


if __name__ == "__main__":
    
    eng_alphabet = EngAlphabet()
    
   
    print("Alphabet letters:")
    eng_alphabet.print()
    
  
    print("\nNumber of letters in the alphabet:")
    print(eng_alphabet.letters_num())
    
  
    print("\nIs 'F' in the English alphabet?")
    print(eng_alphabet.is_en_letter('F'))
    
  
    print("\nIs 'Щ' in the English alphabet?")
    print(eng_alphabet.is_en_letter('Щ'))
    
  
    print("\nExample text in English:")
    print(eng_alphabet.example())

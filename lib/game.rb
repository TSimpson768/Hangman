
class Game

  # This needs to load in dictonary.txt, and sample a random word between 5 and 12
  # characters in length, Create an array of guessed letters, initially empty, and set
  # number of guesses left to 8?
  # For guessing - Either Print any letter in word present in guesses, and print wrong guesses
  # Below
  # Or have a second string guessed_word "______" of same length. When a letter present in the 
  # word is guessed, sub it into guessed_word. If not, add it to an array of wrong guesses, and 
  # Decrement guesses_left. Save guesses made and wrong guesses

  # Also need to be able to set these three from a save file (probably JSON)
  def initialize(secret_word, guessed_word, guesses_left = 8, guessed_letters = [], wrong_letters = [])
    @secret_word = secret_word
    @guessed_word = guessed_word
    @guesses_left = guesses_left
    @guessed_letters = guessed_letters
    @wrong_letters = wrong_letters
  end

  # Create a new game object, with a secret word sampled from dictonary.txt
  def self.new_game
    dictonary = File.new('dictonary.txt', 'r')
    cleaned_dictonary = dictonary.readlines(chomp: true).select { |word| word.length >= 5 && word.length <= 12 }
    dictonary.close
    word = cleaned_dictonary.sample
    Game.new(word, '_' * word.length)
  end

  def play
    while @guesses_left.positive?
      print_man # Print the hangman
      print_guessed # Print the guessed word
      user_input # Save if save is inputed, otherwise check the guess
      break if game_won?
    end
    game_over # Run any game over logic, and ask to play agian
  end

  private

  def print_man
    
  end

  def print_guessed
    
  end

  def user_input
    
  end

  def game_won?
  end

  def game_over
    
  end
end

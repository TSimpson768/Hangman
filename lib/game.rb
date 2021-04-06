# frozen_string_literal: true

require 'json'
# This needs to load in dictonary.txt, and sample a random word between 5 and 12
# characters in length, Create an array of guessed letters, initially empty, and set
# number of guesses left to 8?
# For guessing - Either Print any letter in word present in guesses, and print wrong guesses
# Below
# Or have a second string guessed_word "______" of same length. When a letter present in the
# word is guessed, sub it into guessed_word. If not, add it to an array of wrong guesses, and
# Decrement guesses_left. Save guesses made and wrong guesses

# Also need to be able to set these three from a save file (probably JSON)
class Game
  SAVE_FOLDER = Dir.pwd + '/saves/'
  def initialize
    main_menu
  end

  private

  def set_up_game(secret_word, guessed_word, guesses_left = 8, guessed_letters = [], wrong_letters = [])
    @secret_word = secret_word
    @guessed_word = guessed_word
    @guesses_left = guesses_left
    @guessed_letters = guessed_letters
    @wrong_letters = wrong_letters
    play
  end

  def main_menu
    puts "Welcome to hangman! Would you like to\n1. Start a new game, or\n2. Load a saved game?"
    case gets.chomp.to_i
    when 1 then new_game
    when 2 then load_game
    else
      puts 'Invalid input'
      main_menu
    end
  end

  # Create a new game object, with a secret word sampled from dictonary.txt
  def new_game
    dictonary = File.new('dictonary.txt', 'r')
    cleaned_dictonary = dictonary.readlines(chomp: true).select { |word| word.length >= 5 && word.length <= 12 }
    dictonary.close
    word = cleaned_dictonary.sample
    set_up_game(word, '_' * word.length)
  end

  def play
    while @guesses_left.positive?
      print_man # Print the hangman
      print_guessed # Print the guessed word
      user_input # Save if save is inputed, otherwise check the guess
      break if game_won?
    end
    game_over # Run any game over logic, and ask to play again
  end

  # Read a save file, and attempt to initialize a game from it
  def load_game
    print_saves
    begin
      read_save
    rescue IOError, SystemCallError
      puts 'File not found'
      load_game
    rescue KeyError
      puts "#{file_name} is not a valid savefile"
      load_game
    end
  end

  def read_save
    file_name = input_save_name
    save = File.open(file_name, 'r')
    save_json = JSON.parse(save.read, { symbolize_names: true })
    save.close
    set_up_game(save_json.fetch(:secret_word), save_json.fetch(:guessed_word), save_json.fetch(:guesses_left),
                save_json.fetch(:guessed_letters), save_json.fetch(:wrong_letters))
  end

  def input_save_name
    print 'Enter save name:'
    SAVE_FOLDER + "#{gets.chomp}.JSON"
  end

  def print_man
    puts "#{@guesses_left} wrong guesses left"
  end

  def print_guessed
    puts @guessed_word
    print 'Wrong guesses:'
    @wrong_letters.each { |letter| print " #{letter}" }
    puts
  end

  def user_input
    input = gets.chomp.downcase
    if input == 'save'
      save_game
    elsif input.match(/^[a-z]{1}$/) && !@guessed_letters.include?(input)
      check_guess(input)
    else
      puts 'Invalid input'
      print_guessed
      user_input
    end
  end

  def game_won?
    @secret_word == @guessed_word
  end

  def game_over
    puts "The secret word was #{@secret_word}"
    if game_won?
      puts 'Congratulations! You win!'
    else
      puts 'Better luck next time'
    end
    puts 'Play again? [y/n]'
    Game.new if gets.chomp.downcase == 'y'
  end

  # Saves are serialized in JSON format. This would have been much easier in YAML(Yaml.dump(self))
  def save_game
    file_name = input_save_name
    begin
      save_file = File.new(file_name, 'w')
      save_file.puts generate_save
      save_file.close
      puts 'Game saved!'
    rescue IOError
      puts 'Save failed'
    end
  end

  # Dump contents of the game objects into a JSON string.
  def generate_save
    JSON.dump({
                secret_word: @secret_word,
                guessed_word: @guessed_word,
                guesses_left: @guesses_left,
                guessed_letters: @guessed_letters,
                wrong_letters: @wrong_letters
              })
  end

  # Checks if the given input string is in the secret word
  def check_guess(input)
    @guessed_letters.push(input)
    if @secret_word.match?(input)
      @secret_word.split(//).each_with_index { |char, index| @guessed_word[index] = char if char == input }
    else
      puts 'Incorrect'
      @guesses_left -= 1
      @wrong_letters.push(input)
    end
  end

  # Prints all JSON files in the saves folder to the console
  def print_saves
    puts 'Current saves:'
    Dir.children(SAVE_FOLDER).each { |file| puts file.delete('.JSON') }
  end
end

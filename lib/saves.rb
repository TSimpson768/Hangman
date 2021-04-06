# frozen_string_literal: true

require 'json'

# A module containing the logic relating to saving and loading games
module Saves
  SAVE_FOLDER = Dir.pwd + '/saves/'

  private

  # Read a save file, and attempt to initialize a game from it
  def load_game
    print_saves
    begin
      read_save
    rescue IOError, SystemCallError
      puts 'File not found'
      load_game
    end
  end

  def read_save
    file_name = input_save_name
    save = File.open(file_name, 'r')
    save_json = JSON.parse(save.read, { symbolize_names: true })
    save.close
    save_json
  end

  def input_save_name
    print 'Enter save name:'
    SAVE_FOLDER + "#{gets.chomp}.JSON"
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
end

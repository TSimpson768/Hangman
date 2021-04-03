# frozen_string_literal: true

require_relative 'game'

def main_menu
  puts "Welcome to hangman! Would you like to\n1. Start a new game, or\n2. Load a saved game?"

  case gets.chomp.to_i
  when 1 then Game.new_game.play
  when 2 then Game.load_game
  else
    puts 'Invalid input'
    main_menu
  end
end
main_menu

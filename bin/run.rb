require_relative '../config/environment'

puts "Enter a pet: "
search_term = gets.chomp
pet = Pet.new
pet.search_pet_type(search_term)

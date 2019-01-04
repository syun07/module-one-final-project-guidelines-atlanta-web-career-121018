class CommandLineInterface

  @@apikey = 'b1eab88e7ce8602d4150d991dede49de'

  def greet
    puts "   _.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._ "
    puts " ,'_.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._`."
    puts "( (                                                         ) )"
    puts ") )                                                         ( ("
    puts "( (                                                         ) )"
    puts ") )                                                         ( ("
    puts "( (                                                         ) )"
    puts ') )                 |\_/|        D\___/\                    ( ('
    puts "( (                 (0_0)         (0_o)                     ) )"
    puts ') )                ==(Y)==         (V)"                     ( ('
    puts "( (           ----(u)---(u)----oOo--U--oOo----              ) )"
    puts ") )          _____|_______|_______|_______|____             ( ("
    puts "( (                                                         ) )"
    puts ") )                                                         ( ("
    puts "( (            Welcome to Adopt-Don't-Shop!                 ) )"
    puts ") )                                                         ( ("
    puts "( (                                                         ) )"
    puts ") )                                                         ( ("
    puts "( (                                                         ) )"
    puts ") )                                                         ( ("
    puts "( (_.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._) )"
    puts " `._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._,'"
  end

  def get_username
    puts "Please enter a username:"
    gets.chomp.to_s
  end

  def find_or_create_username(username)
    Caretaker.find_or_create_by(name: username)
    puts "Welcome, #{username}!"
    #use switch statement to say "Welcome back" if you already have an account (if time)
  end

  def get_zip_code
    puts "Please enter your zip code to see shelters near you:"
    zip_code = gets.chomp
  end

  def find_shelters(zip_code)
    url = "http://api.petfinder.com/shelter.find?key=#{@@apikey}&location=#{zip_code}&format=json"
    puts "URL: #{url}"
    response = RestClient.get url
    response_hash = JSON.parse(response.body)

    @zip_shelters = response_hash["petfinder"]["shelters"]["shelter"]

    @shelter_array = @zip_shelters.collect do |shelter|
       shelter["name"]["$t"]
    end
  end


  def get_user_input
    @shelter_array.each.with_index(1) do |shelter, index|
      puts "#{index}: #{shelter}"
    end
    puts "Choose a shelter:"
    input = gets.chomp.to_i
  end


  def shelter_info(input)
     selected_shelter = @shelter_array[input-1]
     #selects shelter name from array using input
  end


  def get_shelter_id(selected_shelter)
    found_id = @zip_shelters.find do |shelter|
       shelter["name"]["$t"] == selected_shelter
         # puts "#{shelter["id"]["$t"]}"
    end
    found_id["id"]["$t"]
  end


  def get_pet(shelter_id, selected_shelter)
    url = "http://api.petfinder.com/shelter.getPets?key=#{@@apikey}&id=#{shelter_id}&status=A&format=json"
    puts url
    response = RestClient.get url
    response_hash = JSON.parse(response.body)

    puts "Here are all the pets available for adoption at #{selected_shelter}:"
    adoptable_pets = response_hash["petfinder"]["pets"]["pet"].collect do |pet|
      pet["name"]["$t"]
    end
    adoptable_pets.each do |pet|
      puts pet
    end
  end


  def adopt_pet(adoptable_pets)
    puts "Which pet would you like to adopt?"
    input = gets.chomp

    my_pet = adoptable_pets.find do |pet|
      input == pet
    end

    Pet.find_or_create_by(name: my_pet)
      puts "Congratulations! You adopted #{my_pet}"
    end





  # def get_type_input
  #   puts "Are you interested in adopting a cat or a dog?"
  #
  #   type_input = gets.chomp
  # end




  # def get_pet(type_input, shelter_id)
  #   # binding.pry
  #   url = "http://api.petfinder.com/pet.getRandom?key=#{@@apikey}&animal=#{type_input}&shelterid=#{shelter_id}&output=basic&format=json"
  #   puts url
  #   response = RestClient.get url
  #   response_hash = JSON.parse(response.body)
  #   binding.pry
  # end


  def run
    greet
    username = get_username
    find_or_create_username(username)
    zip_code = get_zip_code
    @shelter_array = find_shelters(zip_code)
    input = get_user_input
    selected_shelter = shelter_info(input)
    shelter_id = get_shelter_id(selected_shelter)
    adoptable_pets = get_pet(shelter_id, selected_shelter)
    adopt_pet(adoptable_pets)
    # type_input = get_type_input
  end
end


  # def search_pet_type(search_term)
  #   url = "http://api.petfinder.com/pet.find?key=#{@@apikey}&animal=#{search_term}&format=json"
  #   puts "URL: #{url}"
  #   response = RestClient.get url
  #   response_hash = JSON.parse(response.body)
  #   # puts response_hash
  # end

class CommandLineInterface

  @@apikey = 'b1eab88e7ce8602d4150d991dede49de'

  def run
    greet
    username
    menu
  end

#------------GREET------------#

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


  #------------USERNAME------------#

  def username
    puts "Please enter a username:"
    username = gets.chomp.to_s

    @caretaker = Caretaker.find_or_create_by(name: username)
    puts "Welcome, #{username}!"
    puts ""
  end

  #------------MENU------------#

  def menu
    puts "       Main Menu       "
    puts "1. Find shelters near you"
    puts "2. Find a pet at random"
    puts "3. See your pets"

    menu_choice = gets.chomp

    case menu_choice
    when "1"
      zip_code = get_zip_code
      @shelter_array = find_shelters(zip_code)
      input = get_user_input
      selected_shelter = shelter_info(input)
      create_shelter(selected_shelter)
      shelter_id = get_shelter_id(selected_shelter)
      adoptable_pets = get_pet(shelter_id, selected_shelter)
      adopt_pet(adoptable_pets)
      menu
    when "2"
      type_input = get_type_input
      response_hash = pet_response_hash(type_input)
      get_random_pet(response_hash)
      user_input = adopt_user_input(response_hash)
      adopt?(user_input, response_hash)
      menu
    when "3"
      caretaker_pets
      menu
    end
  end


  #------------MENU OPTION 1------------#
    #------------Shelters------------#

  def get_zip_code
    puts "Please enter your zip code to see shelters near you:"
    gets.chomp
  end

  def find_shelters(zip_code)
    #use api to find shelters based on zip code
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
    #print shelters near zip code, user chooses with index
    @shelter_array.each.with_index(1) do |shelter, index|
      puts "#{index}: #{shelter}"
    end
    puts "Choose a shelter to see a list of adoptable pets:"
    gets.chomp.to_i
  end

  def shelter_info(input)
    #get selected shelter name
     @shelter_array[input-1]
  end

  def create_shelter(selected_shelter)
    #create new instance of shelter
    shelter = @zip_shelters.select { |shelter| shelter["name"]["$t"] == selected_shelter }.first
    @shelter = Shelter.find_or_create_by(name: shelter["name"]["$t"])
  end

  def get_shelter_id(selected_shelter)
    #iterate through all shelters to find name that matches selected shelter
    #if matches, get shelter id
    found_id = @zip_shelters.find do |shelter|
       shelter["name"]["$t"] == selected_shelter
    end
    found_id["id"]["$t"]
  end

  def get_pet(shelter_id, selected_shelter)
    #use api & use shelter id to see list of adoptable pets @ shelter
    url = "http://api.petfinder.com/shelter.getPets?key=#{@@apikey}&id=#{shelter_id}&status=A&format=json"
    response = RestClient.get url
    response_hash = JSON.parse(response.body)

    puts "Here are all the pets available for adoption at #{selected_shelter}:"
    #collect adoptable pets & creates new array
    adoptable_pets = response_hash["petfinder"]["pets"]["pet"].collect do |pet|
      pet["name"]["$t"]
    end

    #iterate over array to list each pet
    adoptable_pets.each do |pet|
      puts pet
    end
  end

  def adopt_pet(adoptable_pets)
    puts "Which pet would you like to adopt?"
    input = gets.chomp

    @pet_name = adoptable_pets.find do |pet|
      input == pet
    end

    Pet.find_or_create_by(caretaker_id: @caretaker.id, shelter_id: @shelter.id, name: @pet_name)
      puts "Congratulations! You adopted #{@pet_name}"
      puts ' |\__/,|   (`\        \ ______/ V`-, '
      puts " |_ _  |.--.) )       }        /~~'  "
      puts " ( T   )     /       /_)^ --,r' "
      puts "(((^_(((/(((_/      |b      |b "
      puts ""
    end


#2. Get random pet
  def get_type_input
    puts "Are you interested in adopting a cat or a dog?"
    type_input = gets.chomp
  end

  def pet_response_hash(type_input)
    #get response hash for random pet based on type input
    url = "http://api.petfinder.com/pet.getRandom?key=#{@@apikey}&animal=#{type_input}&output=basic&format=json"
    response = RestClient.get url
    response_hash = JSON.parse(response.body)
  end

  def get_random_pet(response_hash)
    #iterate over response_hash to get information about a random pet
    @random_pet_name = response_hash["petfinder"]["pet"]["name"]["$t"]
    @random_pet_type = response_hash["petfinder"]["pet"]["animal"]["$t"]
    @random_shelter = Shelter.find_or_create_by(name: response_hash["petfinder"]["pet"]["shelterId"]["$t"])

    puts "Name: #{@random_pet_name}"
    puts "  Type: #{@random_pet_type}"
    puts "  Breed: #{response_hash["petfinder"]["pet"]["breeds"]["breed"]["$t"]}"
    puts "  Age: #{response_hash["petfinder"]["pet"]["age"]["$t"]}"
    puts "  Description: #{response_hash["petfinder"]["pet"]["description"]["$t"]}"
    puts ""
  end

  def adopt_user_input(response_hash)
    puts "Would you like to adopt #{@random_pet_name}? (yes or no)"
    gets.chomp
  end

  def adopt?(user_input, response_hash)
    case user_input
    when "yes"
      Pet.find_or_create_by(caretaker_id: @caretaker.id, shelter_id: @random_shelter, name: @random_pet_name, breed: @random_pet_type)
      puts "Congratulations! You adopted #{@random_pet_name}"
      puts ' |\__/,|   (`\        \ ______/ V`-, '
      puts " |_ _  |.--.) )       }        /~~'  "
      puts " ( T   )     /       /_)^ --,r' "
      puts "(((^_(((/(((_/      |b      |b "
    when "no"
      menu
    end
  end


  #---------SEE PETS--------#

  def caretaker_pets
    puts "Your pets:"
    @caretaker.pets.each.with_index(1) do |pet, index|
      puts "#{index}. #{pet.name}"
    end
  end
end

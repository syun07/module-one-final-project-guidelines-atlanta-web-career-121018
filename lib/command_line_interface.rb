class CommandLineInterface

  @@apikey = "b1eab88e7ce8602d4150d991dede49de"

  # def initialize
  #   @zip_shelters = []
  #   @shelter_array = []
  #   @shelter_id = []
  # end

  def greet
    puts "Welcome to Adopt-Don't-Shop!"
  end

  def get_username
    puts "Please enter a username: "
    gets.chomp.to_s
  end

  def find_or_create_username(username)
    Caretaker.find_or_create_by(name: username)
    puts "Welcome, #{username}!"
  end

  def get_zip_code
    puts "Please enter your zipcode to see shelters near you: "
    zip_code = gets.chomp
  end

  def shelter_info(input)
    selected_shelter = @shelter_array[input-1]#returns shelter name
  end

  def find_shelters(zip_code)
    url = "http://api.petfinder.com/shelter.find?key=#{@@apikey}&location=#{zip_code}&format=json"
    # puts "URL: #{url}"
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
    puts "Choose a shelter: "
    input = gets.chomp.to_i
  end

  def shelter_info(input)
    selected_shelter = @shelter_array[input-1]
  end


  def get_shelter_id(selected_shelter)
    found_id = @zip_shelters.find do |shelter|
      shelter["name"]["$t"] == selected_shelter
    end
    found_id["id"]["$t"]
  end

  def get_pet(shelter_id, selected_shelter)
    url = "http://api.petfinder.com/shelter.getPets?key=#{@@apikey}&id=#{shelter_id}&status=A&format=json"
    puts url
    response = RestClient.get url
    response_hash = JSON.parse(response.body)

    puts "Here are all the pets available for adoption at #{selected_shelter}: "
    adoptable_pets = response_hash["petfinder"]["pets"]["pet"].collect do |pet|
      pet["name"]["$t"]
    end
    adoptable_pets.each do |pet|
      puts pet
  end

  def adopt_pet(adoptable_pets)
    puts "Which pet would you like to adopt?"
    input = gets.chomp

    my_pet = adoptable_pets.find do |pet|
      input == pet
    end
    Pet.find_or_create_by(name: my_pet)
    puts "Congratulations! You adopted #{my_pet}!"
    end
  end


  def get_type_input
    puts "Are you interested in adopting a cat or a dog?"
      type_input = gets.chomp
      # @adoptable_pets[type]
      if type_input == dog
        puts "dog picture"
      else
        puts "cat picture"
      end
  end



  # def gets_user_pet_type(shelter)
  #   url = "http://api.petfinder.com/shelter.find?key=#{@@apikey}&animal=#{type_of_animal}&format=json"
  #   puts "URL: #{url}"
    # response = RestClient.get url
    # response_hash = JSON.parse(response.body)

    # @zip_shelters = response_hash
  # end


  # def gets_user_pet_type(shelter)
  #   url = "http://api.petfinder.com/shelter.find?key=#{@@apikey}&animal=#{type_of_animal}&format=json"
  #   puts "URL: #{url}"
    # response = RestClient.get url
    # response_hash = JSON.parse(response.body)

    # @zip_shelters = response_hash
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
    get_pet(shelter_id, selected_shelter)
    adopt_pet(adoptable_pets)
    type_input = get_type_input
  end

end

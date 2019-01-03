class CommandLineInterface

  @@apikey = 'b1eab88e7ce8602d4150d991dede49de'

  def greet
    puts "Welcome to Adopt-Don't-Shop!"
  end

  def create_user
    #create new instance of user based on user input
  end

  def get_zip_code
    puts "Please enter your zip code:"
    zip_code = gets.chomp
  end

  def find_shelters(zip_code)
    url = "http://api.petfinder.com/shelter.find?key=#{@@apikey}&location=#{zip_code}&format=json"
    puts "URL: #{url}"
    response = RestClient.get url
    response_hash = JSON.parse(response.body)


    # @zip_shelters = response_hash["petfinder"]["shelters"]["shelter"].collect do |shelter|
    #    shelter["name"]["$t"]
    # end

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

  def get_type_input
    puts "What kind of pet are you interested in adopting?"
    puts "
    1. Barnyard
    2. Bird
    3. Cat
    4. Dog
    5. Horse
    6. Reptile
    7. Small furry"

    type_input = gets.chomp
  end


  def get_pet(shelter_id)
    url = "http://api.petfinder.com/shelter.getPets?key=#{@@apikey}&id=#{shelter_id}&status=A&format=json"
    puts url
    response = RestClient.get url
    response_hash = JSON.parse(response.body)

    @pet_array = response_hash["petfinder"]["pets"]["pet"].collect do |pet|
      pet["name"]["$t"]
    end
    binding.pry
  end


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
    zip_code = get_zip_code
    @shelter_array = find_shelters(zip_code)
    input = get_user_input
    selected_shelter = shelter_info(input)
    shelter_id = get_shelter_id(selected_shelter)
    type_input = get_type_input
    get_pet(shelter_id)
  end


end




  # http://api.petfinder.com/shelter.getPets?key=b1eab88e7ce8602d4150d991dede49de&id=GA923&format=json



  def search_pet_type(search_term)
    url = "http://api.petfinder.com/pet.find?key=#{@@apikey}&animal=#{search_term}&format=json"
    puts "URL: #{url}"
    response = RestClient.get url
    response_hash = JSON.parse(response.body)
    # puts response_hash
  end
  #
  # def run
  #   greet
  #   search_term = gets.chomp
  #   search_pet_type(search_term)
  # end

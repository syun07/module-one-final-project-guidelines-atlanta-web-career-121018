class CommandLineInterface

  @@apikey = 'b1eab88e7ce8602d4150d991dede49de'

  def initialize
    @zip_shelters = []
    @shelter_array = []
  end

  def greet
    puts "Welcome to Adopt-Don't-Shop!"
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
     @selected_shelter = @shelter_array[input-1]
     #selects shelter name from array using input
  end


  def get_shelter_id
    @shelter_id = @zip_shelters.find do |shelter|
       if shelter["name"]["$t"] == @selected_shelter
         puts "#{shelter["id"]["$t"]}"
       end
    end
  end
  #
  #
  # def get_type_input
  #   puts "What kind of pet are you interested in adopting?"
  #   puts "
  #   1. Barnyard
  #   2. Bird
  #   3. Cat
  #   4. Dog
  #   5. Horse
  #   6. Reptile
  #   7. Small furry"
  #
  #   type_input = gets.chomp
  # end
  #
  # def gets_user_pet_type(type_input)
  #   url = "http://api.petfinder.com/#{@selected_shelter}.listByBreed?key=#{@@apikey}&animal=#{type_input}&breed=breed.list&format=json"
  #   puts url
  # end

  def run
    greet
    zip_code = get_zip_code
    @shelter_array = find_shelters(zip_code)
    input = get_user_input
    @selected_shelter = shelter_info(input)
    @shelter_id = get_shelter_id
    # type_input = get_type_input
    # gets_user_pet_type(type_input)
    # binding.pry
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

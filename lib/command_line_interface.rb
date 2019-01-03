class CommandLineInterface

@@apikey = 'b1eab88e7ce8602d4150d991dede49de'

  def greet
    "Welcome to Adopt-Don't-Shop!"
  end

  def gets_zip_code
    puts "Please enter your zip code: "
    zip_code = gets.chomp
  end

  def find_shelters(zip_code)
    url = "http://api.petfinder.com/shelter.find?key=#{@@apikey}&location=#{zip_code}&format=json"
    puts "URL: #{url}"
    response = RestClient.get url
    response_hash = JSON.parse(response.body)

    arr = []
    response_hash["petfinder"]["shelters"]["shelter"].collect do |shelter|
      arr << shelter["name"].values
    end
    puts arr
  end


  def run
    greet
    zip_code = gets_zip_code
    shelters = find_shelters(zip_code)
  end










  # puts "Welcome! What kind of pet are you interested in adopting?"
  # puts "
  # 1. Barnyard
  # 2. Bird
  # 3. Cat
  # 4. Dog
  # 5. Horse
  # 6. Reptile
  # 7. Small furry"
  #
  # def search_pet_type(search_term)
  #   url = "http://api.petfinder.com/pet.find?key=#{@@apikey}&animal=#{search_term}&format=json"
  #   puts "URL: #{url}"
  #   response = RestClient.get url
  #   response_hash = JSON.parse(response.body)
  #   puts response_hash
  # end
  #
  # def run
  #   greet
  #   search_term = gets.chomp
  #   search_pet_type(search_term)
  # end
end

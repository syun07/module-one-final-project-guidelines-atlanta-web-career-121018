class Pet < ActiveRecord::Base
  belongs_to :caretaker
  belongs_to :shelter

  # @@apikey = 'b1eab88e7ce8602d4150d991dede49de'
  #
  # def search_pet_type(search_term)
  #   url = "http://api.petfinder.com/breed.list?key=#{@@apikey}&animal=#{search_term}&format=json"
  #   puts "URL: #{url}"
  #   response = RestClient.get url
  #   response_hash = JSON.parse(response.body)
  #   # response_hash["breeds"].each do |breed|
  #   #   puts breed
  #   # end
  # end

  # def random(search_term)
  #   url = "http://api.petfinder.com/pet.getRandom?key=b1eab88e7ce8602d4150d991dede49de"
  #   puts "URL: #{url}"
  #   response = RestClient.get url
  #   response_hash = JSON.parse(response.body)
  #   puts response_hash
  # end
end

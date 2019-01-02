# class CommandLineInterface

# @@apikey = 'b1eab88e7ce8602d4150d991dede49de'
#
#   def greet
#     puts "Welcome! What kind of pet are you interested in adopting?"
#     puts "
#     1. Barnyard
#     2. Bird
#     3. Cat
#     4. Dog
#     5. Horse
#     6. Reptile
#     7. Small furry"
#   end
#

#   def search_pet_type(search_term)
#     url = "http://api.petfinder.com/pet.find?key=#{apikey}&animal=#{search_term}&format=json"
#     puts "URL: #{url}"
#     response = RestClient.get url
#     response_hash = JSON.parse(response.body)
#     puts response_hash
#   end
#
#   def run
#     greet
#     search_pet_type(search_term)
#   end
# end

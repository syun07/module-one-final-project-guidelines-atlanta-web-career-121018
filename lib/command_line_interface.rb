class CommandLineInterface

  @@apikey = "b1eab88e7ce8602d4150d991dede49de"

  def greet
    puts "Welcome to Adopt-Don't-Shop!"
  end

  def gets_zip_code
    puts "Please enter your zipcode: "
    zip_code = gets.chomp
  end

  def find_shelters(zip_code)
    url = "http://api.petfinder.com/shelter.find?key=#{@@apikey}&location=#{zip_code}&format=json"
    puts "URL: #{url}"
    response = RestClient.get url
    response_hash = JSON.parse(response.body)

    zip_shelters = []
    response_hash["petfinder"]["shelters"]["shelter"].each do |shelter|
      zip_shelters << shelter["name"].values
    end
    puts zip_shelters
  end

  def run
    greet
    zip_code = gets_zip_code
    find_shelters(zip_code)
  end

end

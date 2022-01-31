require 'net/http'

class HomeController < ApplicationController
  def index

    @BCHQTemp = BigCommerceHeadquarterTemp.all
    puts @BCHQTemp.size
    puts @BCHQTemp[0].date
    puts @BCHQTemp[0].temp





    # getWeatherdata()

    # example = BigCommerceHeadquarterTemp.new
    # example.date = '2022-01-31 03'
    # example.temp = 60
    # example.save

    # puts "Example DATA"
    # puts example.date
    # puts example.temp

  end

  def getWeatherdata
    # Get Weather data via external API
    uri = URI('https://api.worldweatheronline.com/premium/v1/past-weather.ashx?key=d13f831881e94157a6c11348223001&q=30.40,-97.84&date=2022-01-27&enddate=2022-01-28&tp=1&format=json')
    api_data = (Net::HTTP.get(uri))

    data = JSON[api_data]

    puts "Other results are: "
    puts data["data"]["weather"][0]["hourly"][0]["time"]  #time - 0
    puts data["data"]["weather"][0]["hourly"][1]["time"]  #time - 300
    puts data["data"]["weather"][0]["hourly"][1]["tempF"] #tempF - 47 
    puts data["data"]["weather"][0]["hourly"].size        # 24 - how many temp intervals per day

    puts "LOOP results are: "
    number_of_days = data["data"]["weather"].size
    n = 0
    begin
      puts data["data"]["weather"][n]["date"]
      n = n + 1
    end while n < number_of_days
    puts "Done"
  end

end

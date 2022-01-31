require 'net/http'

class HomeController < ApplicationController
  def index

    @BCHQTemp = BigCommerceHeadquarterTemp.all
    # puts @BCHQTemp
    # puts @BCHQTemp[0].date
    # puts @BCHQTemp[0].temp

    # Format Model data for use with Highcharts

    chartArrayFormatted = []
    dataCounter = 0
    begin
      # puts @BCHQTemp[dataCounter].date
      # puts @BCHQTemp[dataCounter].temp

      # Create an array for each date/temp record
      singleHourTemp = []

      #Convert Unix Time - seconds -> ms
      alteredDateFormat = @BCHQTemp[dataCounter].date.to_i * 1000

      singleHourTemp.push(alteredDateFormat, @BCHQTemp[dataCounter].temp)
      chartArrayFormatted.push(singleHourTemp)

      dataCounter = dataCounter + 1
    end while dataCounter < @BCHQTemp.size


    @chartArrayFormatted = chartArrayFormatted
    
    getWeatherdata()
  end

  def getWeatherdata
    # Get Weather data via external API
    uri = URI('https://api.worldweatheronline.com/premium/v1/past-weather.ashx?key=d13f831881e94157a6c11348223001&q=30.40,-97.84&date=2022-01-24&enddate=2022-01-28&tp=1&format=json')
    api_data = (Net::HTTP.get(uri))

    data = JSON[api_data]

    puts "results are: "
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

require 'net/http'
require 'Date'

class HomeController < ApplicationController
  def index

    getWeatherdata()

    formatModelSendToView()

  end

  def getWeatherdata
    # Get Weather data via external API
    uri = URI('https://api.worldweatheronline.com/premium/v1/past-weather.ashx?key=d13f831881e94157a6c11348223001&q=30.40,-97.84&date=2022-01-01&enddate=2022-01-31&tp=1&format=json')
    api_data = (Net::HTTP.get(uri))

    data = JSON[api_data]

    number_of_days = data["data"]["weather"].size
    n = 0
    begin

      i = 0
      begin
        day = data["data"]["weather"][n]["date"]
        hour = data["data"]["weather"][n]["hourly"][i]["time"]
        temp = data["data"]["weather"][n]["hourly"][i]["tempF"]

        # Format hour value from API
        formatedDayHour = combineDayHour(day, hour)

        parsedDate = DateTime.parse(formatedDayHour)
        dateReadyToCreate = parsedDate.strftime('%a %b %d %H:%M:%S %Z %Y')

        #only .create if record doesn't already exist
        if !BigCommerceHeadquarterTemp.exists?(:date => dateReadyToCreate)
          BigCommerceHeadquarterTemp.create(:date => dateReadyToCreate, :temp => temp)
        end

        i += 1
      end while i < data["data"]["weather"][n]["hourly"].size
      
      n += 1
    end while n < number_of_days
    puts "Done"
  end

  #format day and hour values from weather APU, return combined string "YYYY-MM-DD HH"
  def combineDayHour(day, hour)
    if hour.size > 1
      hourFormated = hour.chomp("00")
      newDay = day.dup
      newDay.concat(" ")
      newDay.concat(hourFormated)
    else
      newDay = day.dup
    end

  end

  # Get Objects from Model, pass to View
  def formatModelSendToView()

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

      #Check to see if there is any Data in database
      if @BCHQTemp.size > 0

      singleHourTemp = []

      #Convert Unix Time - seconds -> ms
      alteredDateFormat = @BCHQTemp[dataCounter].date.to_i * 1000

      singleHourTemp.push(alteredDateFormat, @BCHQTemp[dataCounter].temp)
      chartArrayFormatted.push(singleHourTemp)

      dataCounter = dataCounter + 1

      end

    end while dataCounter < @BCHQTemp.size

    @chartArrayFormatted = chartArrayFormatted

  end


end

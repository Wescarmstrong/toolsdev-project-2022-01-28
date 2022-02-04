require 'net/http'
require 'date'

class HomeController < ApplicationController
  def index

    getWeatherdata()

    formatModelSendToView()

  end

  def getWeatherdata
    # Get Weather data via external API

    #Get time and format for use in weather API request
    currentTime = (Time.now + 0.day).strftime("%Y-%m-%d")
    currentTimeMinus30Days = (Time.now.midnight - 30.day).strftime("%Y-%m-%d")
    #TODO Use generated times above in URL request below

    # Retrieves encrypted weather API key  
    weather_api_key = Rails.application.credentials.weather_api_key

    uri = URI("https://api.worldweatheronline.com/premium/v1/past-weather.ashx?key=#{weather_api_key}&q=30.40,-97.84&date=#{currentTimeMinus30Days}&enddate=#{currentTime}&tp=1&format=json")
    api_data = (Net::HTTP.get(uri))

    data = JSON[api_data]

    # TODO: Check to see if number_of_days has a size/ exists before code below
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

    # @dataForView = BigCommerceHeadquarterTemp.all

    @dataForView = BigCommerceHeadquarterTemp.where(date: (Time.now.midnight - 30.day)..Time.now)
    # puts @dataForView


    # Format Model data for use with Highcharts
    chartArrayFormatted = []
    dataCounter = 0
    begin

      # Create an array for each date/temp record

      #Check to see if there is any Data in database
      if @dataForView.size > 0

      singleHourTemp = []

      #Convert Unix Time - seconds -> ms
      alteredDateFormat = @dataForView[dataCounter].date.to_i * 1000

      singleHourTemp.push(alteredDateFormat, @dataForView[dataCounter].temp)
      chartArrayFormatted.push(singleHourTemp)

      dataCounter = dataCounter + 1

      end

    end while dataCounter < @dataForView.size

    @chartArrayFormatted = chartArrayFormatted

  end


end

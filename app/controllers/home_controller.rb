require 'net/http'
require 'date'

class HomeController < ApplicationController
  def index

    getWeatherData()

  end

  def ajaxWeather
    getWeatherData()
    @ajaxData = formatModelForAjax()
  end
  
  def getWeatherData
    # Get Weather data via external API

    # Format time for use in weather API request
    currentTime = (Time.now + 2.day).strftime("%Y-%m-%d")
    currentTimeMinus30Days = (Time.now.midnight - 30.day).strftime("%Y-%m-%d")

    # Retrieves encrypted weather API key  
    weather_api_key = Rails.application.credentials.weather_api_key

    uri = URI("https://api.worldweatheronline.com/premium/v1/past-weather.ashx?key=#{weather_api_key}&q=30.40,-97.84&date=#{currentTimeMinus30Days}&enddate=#{currentTime}&tp=1&format=json")
    api_data = (Net::HTTP.get(uri))

    data = JSON[api_data]

    puts "number_of_days before assign =:  #{data["data"]["weather"].size}"
    number_of_days = data["data"]["weather"].size
    puts "number_of_days =:  #{number_of_days}"

    # Make sure api call was successful before creating temp records
    if number_of_days > 0  
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

          # Only .create if record doesn't already exist
          if !BigCommerceHeadquarterTemp.exists?(:date => dateReadyToCreate)
            BigCommerceHeadquarterTemp.create(:date => dateReadyToCreate, :temp => temp)
          end

          i += 1
        end while i < data["data"]["weather"][n]["hourly"].size
        
        n += 1
      end while n < number_of_days
    end  
  end

  # Format day and hour values from weather API, return combined string "YYYY-MM-DD HH"
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

  # Get records from Model, pass to View
  def formatModelForAjax()

    @dataForView = BigCommerceHeadquarterTemp.where(date: (Time.now.midnight - 30.day)..Time.now + 2.day)

    # Order the database records, Highcharts requires data to be in correct order
    @orderedResults = @dataForView.order('date ASC').limit(@dataForView.size)

    # Format Model data for use with Highcharts
    chartArrayFormatted = []
    dataCounter = 0

    if @dataForView.size > 0
      # Create an array for each date/temp record
      # Check to see if there is any Data in database
      begin
      singleHourTemp = []

      # Convert Unix Time from seconds -> ms
      alteredDateFormat = @orderedResults[dataCounter].date.to_i * 1000

      singleHourTemp.push(alteredDateFormat, @orderedResults[dataCounter].temp)
      chartArrayFormatted.push(singleHourTemp)

      dataCounter = dataCounter + 1

      end while dataCounter < @orderedResults.size
    end

    # Ensure Data provided to View is correct length
    lengthOfData = chartArrayFormatted.length
    if (lengthOfData % 3 == 0) 
    elsif (lengthOfData % 3 == 1)
      chartArrayFormatted.shift
    else
      chartArrayFormatted.shift(2)
    end

    @chartArrayFormatted = chartArrayFormatted

  end

end

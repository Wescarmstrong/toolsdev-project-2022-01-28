$ ->

ajaxData = {}
$.ajax '/indexajax',
  success: (data) ->
    callback data
    console.log 'ajax succes: '
  error: (data) ->
    console.log 'ajax error: ', data

callback = (data) ->
  ajaxDataCallback = data
  ajaxData = {}
  ajaxData = ajaxDataCallback
  

  createHistoricalChart = ->
    Highcharts.stockChart 'hourly_chart',
      rangeSelector: selected: 4
      title: text: 'Weather for Austin HQ'
      credits: enabled: false
      series: historicalSeries
    console.log historicalSeries
    return

  historicalSuccess = (data, name) ->
    `var name`
    name = name
    i = historicalname.indexOf(name)
    historicalSeries[i] =
      name: name
      data: data
    historicalCounter += 1
    if historicalCounter == historicalname.length
      createHistoricalChart()
    return

  createHighLowChart = ->
    Highcharts.stockChart 'highs-lows_chart',
      rangeSelector: selected: 4
      title: text: '3-Hour Highs and Lows'
      credits: enabled: false
      series: highLowSeries
    return

  highLowsuccess = (data, name) ->
    `var name`
    name = name
    i = highLowNames.indexOf(name)
    highLowSeries[i] =
      name: name
      data: data
    highLowSeriesCounter += 1
    if highLowSeriesCounter == highLowNames.length
      createHighLowChart()
    return

  buildMaxMinSeries = (threeSplicedTemps) ->
    threeTemps = []
    splicedTemps = threeSplicedTemps

    findMaxMinTemp = (obj) ->
      threeHourDate = obj[2][0]
      obj.forEach returnHighestTemp
      maxMin = getMinMax(threeTemps)
      maxArray = [
        threeHourDate
        maxMin[0]
      ]
      minArray = [
        threeHourDate
        maxMin[1]
      ]
      highSeries.push maxArray
      lowSeries.push minArray
      return

    returnHighestTemp = (item, index) ->
      threeTemps.push item[1]
      return

    getMinMax = (arr) ->

      Array::max = ->
        Math.max.apply null, this

      Array::min = ->
        Math.min.apply null, this

      maximum = arr.max()
      minimum = arr.min()
      result = [
        maximum
        minimum
      ]
      result

    findMaxMinTemp splicedTemps
    return

  historicalSeries = []
  historicalCounter = 0
  historicalname = [ 'historical' ]
  highLowSeries = []
  highSeries = []
  lowSeries = []
  highLowSeriesCounter = 0
  highLowNames = [
    'High'
    'Low'
  ]


  callbackWeatherData = (data) ->
    weatherData = JSON.parse(data)
    historicalSuccess weatherData, 'historical'

    weatherData = JSON.parse(JSON.stringify(weatherData))
    numberOfIteration = weatherData.length / 3
    i = 0
    while i < Math.floor(numberOfIteration)
      splicedData = weatherData.splice(0, 3)
      buildMaxMinSeries splicedData
      i += 1
    highLowsuccess highSeries, 'High'
    highLowsuccess lowSeries, 'Low'
    return

    # console.log("TEST ajaxData IN LIL SCOPE ", ajaxData)

  run = () ->
    # console.log("run was called!")
    callbackWeatherData ajaxData
  setTimeout(run, 0)

# runLater = () ->
# console.log("runLater was called!")

# $.ajax '/indexajax',
#   success: (data) ->
#     callback data
#     console.log 'ajax succes: '
#   error: (data) ->
#     console.log 'ajax error: ', data

#     # callbackWeatherData ajaxData
# setInterval(runLater, 3000)


#   $(document).ready -> console.log("Jquery is present")
# $(document).ready -> console.log("ajaxData is present", ajaxData)

  
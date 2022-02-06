$ ->

# Begin ajax request
ajaxData = {}
$.ajax '/indexajax',
  success: (data) ->
    callback data
    console.log 'ajax succes: '
  error: (data) ->
    console.log 'ajax error: ', data

# Callback is required due to asynchronous nature of ajax
callback = (data) ->
  ajaxDataCallback = data
  ajaxData = {}
  ajaxData = ajaxDataCallback
  
  # Define a historical stockchart
  createHistoricalChart = ->
    Highcharts.stockChart 'hourly_chart',
      rangeSelector: selected: 4
      title: text: 'Weather for Austin HQ'
      credits: enabled: false
      legend:
        enabled: true
        align: 'center'
        verticalAlign: 'bottom'
      series: historicalSeries
	# log the data provided to View, for troubleshooting purposes   
    console.log historicalSeries
    return

  # Creates a historical stockchart
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

  # Define a High/Low stockchart
  createHighLowChart = ->
    Highcharts.stockChart 'highs-lows_chart',
      rangeSelector: selected: 4
      title: text: '3-Hour Highs and Lows'
      credits: enabled: false
      legend:
        enabled: true
        align: 'center'
        verticalAlign: 'bottom'
      series: highLowSeries
    return

  # Creates a High/Low stockchart
  highLowsuccess = (data, name) ->
    name = name
    i = highLowNames.indexOf(name)
    highLowSeries[i] =
      name: name
      data: data
    highLowSeriesCounter += 1
    if highLowSeriesCounter == highLowNames.length
      createHighLowChart()
    return

  # Calculate the High/Low temps within 3 hour time intervals
  buildMaxMinSeries = (threeSplicedTemps) ->
    threeTemps = []
    splicedTemps = threeSplicedTemps

    findMaxMinTemp = (obj) ->
      threeHourDate = obj[2][0]
      obj.forEach returnHighLowTemps
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

	# Pushes High/Low temp within interval onto threeTemps array
    returnHighLowTemps = (item, index) ->
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
  historicalname = [ 'Historical' ]
  highLowSeries = []
  highSeries = []
  lowSeries = []
  highLowSeriesCounter = 0
  highLowNames = [
    'High'
    'Low'
  ]

  # Call methods to display charts
  callbackWeatherData = (data) ->
    weatherData = JSON.parse(data)
    historicalSuccess weatherData, 'Historical'

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

  # This can be changed and set up with ajax to setInterval for automatic asynchronous updates
  run = () ->
    callbackWeatherData ajaxData
  setTimeout(run, 0)


  
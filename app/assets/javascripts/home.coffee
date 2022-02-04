$ ->
  highLowElement = document.getElementById('highs-lows_chart')
  dataTestDB = JSON.parse(highLowElement.getAttribute('data-test'))

  createHistoricalChart = ->
    Highcharts.stockChart 'hourly_chart',
      rangeSelector: selected: 4
      title: text: 'Weather for Austin HQ'
      credits: enabled: false
      series: historicalSeries
    console.log historicalSeries
    return

  hSuccess = (data, name) ->
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

  success = (data, name) ->
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
      threeHourDate = obj[0][0]
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

  console.log 'Number of database records received: ' + dataTestDB.length
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
  hSuccess dataTestDB, 'historical'
  hData = JSON.parse(JSON.stringify(dataTestDB))
  numberOfIteration = hData.length / 3
  i = 0
  while i < Math.floor(numberOfIteration)
    splicedData = hData.splice(0, 3)
    buildMaxMinSeries splicedData
    i += 1
  success highSeries, 'High'
  success lowSeries, 'Low'
  return

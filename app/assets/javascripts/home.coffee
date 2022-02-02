
# Create chart after page loads
`$(function () {

    let highLowElement = document.getElementById('highs-lows_chart');
    let dataTestDB = JSON.parse(highLowElement.getAttribute('data-test'));

    console.log("Number of database records received: " + dataTestDB.length);
   
    let historicalSeries = [];
	historicalCounter = 0;
	historicalname = ['historical'];
    let highLowSeries = [];
    let highSeries = [];
    let lowSeries = [];
	highLowSeriesCounter = 0;
	highLowNames = ['High', 'Low'];

	
	function createHistoricalChart() {

		Highcharts.stockChart('hourly_chart', {

			rangeSelector: {
				selected: 4
			},

			title: {
				text: 'Weather for Austin HQ'
			},
            credits: {
                enabled: false
            },

			series: historicalSeries
		});
        console.log(historicalSeries);
	}

		function hSuccess(data, name) {
			var name = name
			var i = historicalname.indexOf(name);
			historicalSeries[i] = {
			name: name,
			data: data
		};

		historicalCounter += 1;

		if (historicalCounter === historicalname.length) {
			createHistoricalChart();
		}
		}

    hSuccess(dataTestDB, 'historical')

	
	function createHighLowChart() {

		Highcharts.stockChart('highs-lows_chart', {

			rangeSelector: {
				selected: 4
			},

			title: {
				text: '3-Hour Highs and Lows'
			},
            credits: {
                enabled: false
            },

			series: highLowSeries
		});
	}

		function success(data, name) {
			var name = name
			var i = highLowNames.indexOf(name);
			highLowSeries[i] = {
			name: name,
			data: data
		};

		highLowSeriesCounter += 1;

		if (highLowSeriesCounter === highLowNames.length) {
			createHighLowChart();
		}
		}


    let hData = JSON.parse(JSON.stringify(dataTestDB));
    let numberOfIteration = hData.length / 3;

    for (let i = 0; i < Math.floor(numberOfIteration); i +=1) {
        let splicedData = hData.splice(0,3);
        buildMaxMinSeries(splicedData);
    }

    function buildMaxMinSeries(threeSplicedTemps) {

        let threeTemps = []
        function findMaxMinTemp(obj) {
            
            let threeHourDate = obj[0][0];

            obj.forEach(returnHighestTemp)
            let maxMin = getMinMax(threeTemps);

            let maxArray = [threeHourDate, maxMin[0]]
            let minArray = [threeHourDate, maxMin[1]]

        highSeries.push(maxArray);
        lowSeries.push(minArray);
            
        };

        function returnHighestTemp(item, index) {
            threeTemps.push(item[1]);
        };

        function getMinMax(arr) {
            let maximum = Math.max(...arr);
            let minimum = Math.min(...arr);
            let result =  ([maximum, minimum]); 
            return result;
        };

        let splicedTemps = threeSplicedTemps
        findMaxMinTemp(splicedTemps);

    };

    success(highSeries, 'High')
    success(lowSeries, 'Low')


});`

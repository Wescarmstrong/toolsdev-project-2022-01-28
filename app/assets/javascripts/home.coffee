
# Create chart after page loads
`$(function () {

    let testEle = document.getElementById('highs-lows_chart');
    let dataTestDB = JSON.parse(testEle.getAttribute('data-test'));

    console.log(dataTestDB.length);
   

	let seriesOptions = [],
	seriesCounter = 0,
	names = ['High', 'Low'];

	
	function createChart() {

		Highcharts.stockChart('highs-lows_chart', {

			rangeSelector: {
				selected: 4
			},

			title: {
				text: 'Highs/Lows Chart'
			},
            credits: {
                enabled: false
            },

			series: seriesOptions
		});
	}

		function success(data, name) {
			var name = name
			var i = names.indexOf(name);
			seriesOptions[i] = {
			name: name,
			data: data
		};

		seriesCounter += 1;

		if (seriesCounter === names.length) {
			createChart();
		}
		}

    success(dataTestDB, 'High')
    success(dataTestDB, 'Low')



});`

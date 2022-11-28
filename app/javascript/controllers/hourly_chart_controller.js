import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hourly-chart"
export default class extends Controller {
  connect() {
    this.chart = this.element.querySelector("#hourly-chart");
    this.getChartData();
  }

  getChartData(){
    fetch('/hourlychart', {
      method: 'GET',
      headers: {
        'X-CSRF-Token': self.token,
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
    .then((response) => response.json())
    .then (this.renderData.bind(null, this))
  }

  renderData(self, data){
    console.log(data);

    let series = self.formatSeries(data);
    let config = self.getChartConfig(data, series);
    Highcharts.chart(self.chart, config);
  }

  formatSeries(data){
    let values = []
    data.forEach((k)=> {
      var timeTaken = new Date(k.time_taken);
      var timeTakenTimeStamp = timeTaken.getTime(timeTaken);
      values.push([timeTakenTimeStamp, Number(k.temp)]);
    })
    
    let timeTakenStart = new Date(data[0].time_taken);
    let timeTakenStartTimeStamp = timeTakenStart.getTime(timeTakenStart);

    let timeTakenInterval = new Date(data[1].time_taken);
    let timeTakenIntervalTimeStamp = timeTakenInterval.getTime(timeTakenInterval);

    let hourly_starttime = (timeTakenStartTimeStamp + Number(data[0].utc_offset)) * 1000;
    let pointInterval = (timeTakenIntervalTimeStamp - timeTakenStartTimeStamp) * 1000;
    let unit = "°F";

    var series = {
        name: "temperature",
        data: values,
        yAxis: 0,
        pointStart:hourly_starttime,
        pointInterval: pointInterval,
        tooltip: {
            valueSuffix: " " + unit,
        }
    };

    return [series];
  }

  getChartConfig(data, series){
    return {

      title: {
        text: 'Hourly'
      },
  
      subtitle: {
        text: ``
      },

      chart: {
        zoomType: 'x'
      },    
  
      yAxis: [{
        title: {
          text: "°F"
        }
      }],
      xAxis: {
        type: 'datetime',
        plotLines: [{
          value: Date.now() + Number(data[0].utc_offset) * 1000,
          color: 'red',
          width: 2
        }],
        plotBands: [],
        labels: {
          formatter: function() {
            var Pharases = {
              AM: 'AM',
              PM: 'PM'
            },
            hour = Highcharts.dateFormat('%H', this.value),
            suf = hour < 12 ? Pharases.AM : Pharases.PM;
  
            return Highcharts.dateFormat("%I:%M", this.value) + ' ' + suf;
          }
        }
      },
      credits: {
        enabled: false
      },
      legend: {
        enabled:false,
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
      },
      exporting: {
        buttons: {
            contextButton: {
                enabled: false
            }    
        }
      },
      plotOptions: {
        series: {
            label: {
                connectorAllowed: false
            },
        }
      },
  
      series: series,
  
      responsive: {
        rules: [{
            condition: {
                maxWidth: 800
            },
            chartOptions: {
                legend: {
                    layout: 'horizontal',
                    align: 'center',
                    verticalAlign: 'bottom'
                }
            }
        }]
      },
      tooltip: {
        shared: true,
        formatter:function() {
          var Pharases = {
            AM: 'AM',
            PM: 'PM'
          },
          hour = Highcharts.dateFormat('%H', this.value),
          suf = hour < 12 ? Pharases.AM : Pharases.PM;

          ;

          return '<b>' + Highcharts.numberFormat(this.y, 0) + ' °F</b><br/>' +
              Highcharts.dateFormat("%a %I:%M", this.x) + ' ' + suf;
        }
      }
    }
  }

  disconnect() {
    this.chart = null;
  }
}

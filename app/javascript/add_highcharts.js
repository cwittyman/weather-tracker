import Highcharts from 'highcharts';
require("highcharts/modules/data")(Highcharts)
require("highcharts/modules/exporting")(Highcharts)
require("highcharts/modules/offline-exporting")(Highcharts)
require("highcharts/modules/map")(Highcharts)
window.Highcharts = Highcharts;
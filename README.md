# README
Ruby on Rails App for tracking Weather

Visit on Heroku [Here](https://cwitty-weather.herokuapp.com/)

Setup

```
git clone git@github.com:cwittyman/weather-tracker.git
bundle install
yarn install
./bin/setup
rake db:migrate
./bin/dev
```


Model Structure

Location
    has_many :forecasts

Forecast < ActiveRecord::Base
    belongs_to : location

CurrentForecast < Forecast

DailyForecast < Forecast

HourlyForecast < Forecast

#sources

Weather APIs

https://open-meteo.com/en/docs
https://openweathermap.org/weather-conditions

UI

https://materializecss.com/
https://www.highcharts.com/
https://github.com/stimulus-use/stimulus-use

Date fun

https://stackoverflow.com/questions/1048937/how-do-i-change-the-zone-offset-for-a-time-in-ruby-on-rails

Testing

https://betterprogramming.pub/how-to-set-up-rails-with-rspec-capybara-and-database-cleaner-aacb000070ef
https://www.fastruby.io/blog/testing/javascript/mocking-js-requests.html
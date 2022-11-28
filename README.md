# README
App for tracking Weather

Setup

```
./bin/setup
rake db:migrate
rails s
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

Date fun
https://stackoverflow.com/questions/1048937/how-do-i-change-the-zone-offset-for-a-time-in-ruby-on-rails

Testing
https://betterprogramming.pub/how-to-set-up-rails-with-rspec-capybara-and-database-cleaner-aacb000070ef
https://www.fastruby.io/blog/testing/javascript/mocking-js-requests.html
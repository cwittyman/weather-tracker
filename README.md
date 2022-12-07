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


# Model Structure

Location
    has_many :forecasts

Forecast < ActiveRecord::Base
    belongs_to : location

CurrentForecast < Forecast

DailyForecast < Forecast

HourlyForecast < Forecast

# Sources

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


repsec 
in mem
subject(:location) {build(:location) }
save
subject(:location) {create(:location) }


you can put before
before { location.save}


code
def weather_data
    @weather_data ||= begin
        response = Res
        activesupport ....
    end
end

test

// mock the method
let(:weather_data) do
 ... json mock
end

expect(location).to receive(:weather_data).at_least(3).and_return(test_weather_data)


create_list(:forecast, 2, location: location, type: ....)


def set_timezone(&block)
    Time.use_zone('EST', &block)
    # Time.use_zone('EST') { index } # index or another action
end

https://guides.rubyonrails.org/association_basics.html#polymorphic-associations

looking up routes
be rails routes -g forecasts


link_to
migrations add/remove fields 
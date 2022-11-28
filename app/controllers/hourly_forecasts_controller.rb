class HourlyForecastsController < ApplicationController
    def index
        
        if Location.find_by(is_selected: true) == nil
            redirect_to locations_path
        else
            @location = Location.find_by(is_selected: true)
            @hourly = @location
                        .forecasts
                        .where(type:"HourlyForecast")
                        .where('time_taken BETWEEN ? AND ?', Time.now.utc, 1.day.from_now)
            
            
            @forecasts = []
            
            # TODO: going cheap, using sqllite, this should be done with postgres and timezones ....
            @hourly.each do |value|
                currentDate = TZInfo::Timezone.get(value.timezone).utc_to_local(Time.now.utc)
                valueDate = TZInfo::Timezone.get(value.timezone).utc_to_local(value.time_taken)

                obj = HourlyForecast.new(value.attributes)

                if currentDate < valueDate
                    @forecasts << obj
                end
            end
        end
    end

    def chart
        todayDate = Date.today
        toDate = todayDate.advance(days: 1)
        #https://stackoverflow.com/questions/1048937/how-do-i-change-the-zone-offset-for-a-time-in-ruby-on-rails
        #ActiveSupport::TimeZone['America/New_York'].parse(Time.now.utc.asctime)
        #ActiveSupport::TimeZone['America/New_York'].parse(Time.now.iso8601)
        @forecasts = Location.find_by(is_selected: true)
                        .forecasts
                        .where(type:"HourlyForecast")
                        .where('time_taken BETWEEN ? AND ?', todayDate, toDate)
                        
        render :json => @forecasts
    end
end

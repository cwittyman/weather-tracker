class DailyForecastsController < ApplicationController
    def index
        if Location.find_by(is_selected: true) == nil
            redirect_to locations_path 
        else
            @location = Location.find_by(is_selected: true)
            @location.create_daily_data
            @dailyforecasts = Location.find_by(is_selected: true).forecasts.where(type:"DailyForecast")
        end
    end
end
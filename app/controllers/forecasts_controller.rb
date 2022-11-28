class ForecastsController < ApplicationController
    def index
        if Location.find_by(is_selected: true) == nil
            redirect_to locations_path 
        else
            if params[:format]
                Location.update_all(:is_selected => false);
                @location = Location.find(params[:format])
                @location.is_selected = true;
                @location.save!
                @location = Location.find_by(is_selected: true)
                
                if Time.now.utc > @location.forecasts.where(type:"CurrentForecast").first.time_taken + 1.hour
                    @location.create_daily_data(true)
                end 

                @forecasts = Location.find_by(is_selected: true).forecasts.where(type:"CurrentForecast")
                
            else
                @location = Location.find_by(is_selected: true)
                
                if Time.now.utc > @location.forecasts.where(type:"CurrentForecast").first.created_at + 1.hour
                    @location.create_daily_data(true)
                end 
                
                @forecasts = @location.forecasts.where(type:"CurrentForecast")
            end
        end
    end
end

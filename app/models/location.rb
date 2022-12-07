class Location < ApplicationRecord
    validates_presence_of :name, :lat, :lng, :timezone

    has_many :forecasts, dependent: :destroy

    def create_daily_data(only_current = false)
        existing = forecasts.where('time_taken BETWEEN ? AND ?', sixth_day, to_date)
        if(!only_current && existing.count > 0)
            return;
        end
        
        if(!only_current && forecasts.count > 0)
            forecasts.destroy_all
        end

        if(!only_current)
            insert_current_data(timezone, weather_data)
            insert_hourly_data(timezone, weather_data)
            insert_daily_data(timezone, weather_data)
        else
            forecasts.where(type:"CurrentForecast").destroy_all
            insert_current_data(timezone, weather_data)
        end
    end

    def weather_data
        @weather_data ||= WeatherData.new(lat, lng, timezone, today_date).response
    end

    private

    def today_date
        Date.today
    end

    def to_date
        # today_date.advance(days: 7)
        7.days.after(today_date)
    end

    def sixth_day
        # to_date - 1.day
        1.day.before(to_date)
    end
    
    def insert_current_data(timezone, data)
        Forecast.find_or_create_by(
            time_taken: data['current_weather']['time'],
            temp: data['current_weather']['temperature'],
            code: data['current_weather']['weathercode'],
            utc_offset: Time.now.in_time_zone(timezone).utc_offset,
            timezone: timezone,
            location_id: id,
            type: 'CurrentForecast'
        )
    end

    def insert_hourly_data(timezone, data)
        combined = data['hourly']['time'].zip(
            data['hourly']['weathercode'],
            data['hourly']['temperature_2m']
        )

        combined.each do |combo|
            time = combo[0]
            code = combo[1]
            temp = 0
            
            if combo[2].is_a? Float
                temp = combo[2]
            else
                #binding.pry
                temp = combo[2].value.split('.', -1)[0]
            end

            Forecast.find_or_create_by(
                time_taken: time,
                temp: temp,
                code: code,
                utc_offset: Time.now.in_time_zone(timezone).utc_offset,
                timezone: timezone,
                location_id: id
            )
        end
    end

    def insert_daily_data(timezone, data)
        combined = data['daily']['time'].zip(
            data['daily']['weathercode'], 
            data['daily']['temperature_2m_min'],
            data['daily']['temperature_2m_max'],
            data['daily']['sunrise'],
            data['daily']['sunset']
        )

        combined.each do |combo|
            Forecast.find_or_create_by(
                time_taken: combo[0],
                code: combo[1],
                mintemp: combo[2],
                maxtemp: combo[3],
                sunrise: combo[4],
                sunset: combo[5],
                utc_offset: Time.now.in_time_zone(timezone).utc_offset,
                timezone: timezone,
                location_id: id,
                type: 'DailyForecast'
            )
        end
    end
end
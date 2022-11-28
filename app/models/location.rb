class Location < ApplicationRecord
    has_many :forecasts
    
    def create_daily_data(only_current = false)

        todayDate = Date.today
        toDate = todayDate.advance(days: 7)
        sixthDay = todayDate.advance(days: 6)
        
        existing = forecasts.where('time_taken BETWEEN ? AND ?', sixthDay, toDate)
        if(!only_current && existing.count > 0)
            return;
        end
        
        if(!only_current && forecasts.count > 0)
            forecasts.destroy_all
        end

        url="https://api.open-meteo.com/v1/forecast?"\
        "latitude=#{lat}"\
        "&longitude=#{lng}"\
        "&hourly=temperature_2m,weathercode"\
        "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&temperature_unit=fahrenheit"\
        "&precipitation_unit=inch"\
        "&timezone=#{Rack::Utils.escape(timezone)}"\
        "&start_date=#{todayDate.strftime('%Y-%m-%d')}"\
        "&end_date=#{toDate.strftime('%Y-%m-%d')}"
        
        response = RestClient.get(url)
        data = ActiveSupport::JSON.decode(response)

        if(!only_current)
            insert_current_data(timezone, data)
            insert_hourly_data(timezone, data)
            insert_daily_data(timezone, data)
        else
            forecasts.where(type:"CurrentForecast").destroy_all
            insert_current_data(timezone, data)
        end
    end

    private
    
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
                binding.pry
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
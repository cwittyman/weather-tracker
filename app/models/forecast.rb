class Forecast < ApplicationRecord
    # def time_taken
    #     TZInfo::Timezone.get(self[:timezone]).utc_to_local(self[:time_taken])
    # end
    CODE_MAP = {
        '0' => "fair",
        '1' => "mainly clear", 
        '2' => "partly cloudy", 
        '3' => "overcast", 
        '45' => "fog", 
        '48' => "depositing rime fog", 
        '51' => "light drizzle", 
        '53' => "moderate drizzle", 
        '55' => "dense drizzle", 
        '56' => "light freezing drizzle", 
        '57' => "dense freezing drizzle",
        '61' => "slight rain",
        '63' => "moderate rain", 
        '65' => "heavy rain",
        '66' => "light freezing rain",
        '67' => "heavy freezing rain",
        '71' => "slight snow fall", 
        '73' => "moderate snow fall", 
        '75' => "heavy snow fall", 
        '77' => "snow grains", 
        '80' => "slight rain showers", 
        '81' => "moderate rain showers", 
        '82' => "heavy rain showers",
        '85' => "slight snow showers",
        '86' => "heavy snow showers",
        '95' => "slight to moderate thunderstorm", 
        '96' => "thunderstorm with slight hail", 
        '99' => "thunderstorm with heavy hail"
    }.freeze

    CODE_MAP_IMG = {
        '0' => "01",
        '1' => "02", 
        '2' => "03", 
        '3' => "04", 
        '45' => "50", 
        '48' => "50", 
        '51' => "09", 
        '53' => "09", 
        '55' => "09", 
        '56' => "09", 
        '57' => "09",
        '61' => "09",
        '63' => "10", 
        '65' => "10",
        '66' => "09",
        '67' => "10",
        '71' => "13", 
        '73' => "13", 
        '75' => "13", 
        '77' => "13", 
        '80' => "09", 
        '81' => "10", 
        '82' => "10",
        '85' => "13",
        '86' => "13",
        '95' => "11", 
        '96' => "11", 
        '99' => "11"
    }.freeze


    def status
        return CODE_MAP[code.to_s]
    end

    def status_img_path(dynamic = true)
        imgCode = CODE_MAP_IMG[code.to_s]
        itemTime = TZInfo::Timezone.get(timezone).utc_to_local(time_taken)
        timeOfDate = "d"
        
        today = Date.today
        tomorrow = today + 1
        
        nine_pm = Time.new(today.year, today.month, today.day, 18, 0, 0).utc
        nine_am = Time.new(tomorrow.year, tomorrow.month, tomorrow.day, 7, 0, 0).utc

        #binding.pry
        # TODO: Pretty sure this is wrong
        if dynamic && ((localize_time(timezone, nine_pm)..localize_time(timezone, nine_am)).include? itemTime)
            timeOfDate = "n"
        end

        return "/assets/#{imgCode}#{timeOfDate}.svg"
    end

    def localize_time(time_zone_param, time_taken_param)
        timeForamted = TZInfo::Timezone.get(time_zone_param).utc_to_local(time_taken_param)
        return timeForamted
    end
end

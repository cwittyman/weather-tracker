class DailyForecast < Forecast
    belongs_to :location

    def format_time
        timeFormated = TZInfo::Timezone.get(timezone).utc_to_local(time_taken).strftime('%a')
        return timeFormated
    end

end
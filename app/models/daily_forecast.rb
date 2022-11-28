class DailyForecast < Forecast
    belongs_to :location

    def format_time
        timeForamted = TZInfo::Timezone.get(timezone).utc_to_local(time_taken).strftime('%a')
        return timeForamted
    end

end
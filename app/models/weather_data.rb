class WeatherData
  attr_reader :lat, :lng, :timezone, :today_date
  
  def initialize(lat, lng, timezone = 'America / New York', today_date = Date.today)
    @lat = lat
    @lng = lng
    @timezone = timezone
    @today_date = today_date
  end
  
  def response
    @response ||= begin
      raw_response = RestClient.get(url)
      ActiveSupport::JSON.decode(raw_response)
    end
  end
  
  private
  
  def url
    "https://api.open-meteo.com/v1/forecast?"\
      "latitude=#{lat}"\
      "&longitude=#{lng}"\
      "&hourly=temperature_2m,weathercode"\
      "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&temperature_unit=fahrenheit"\
      "&precipitation_unit=inch"\
      "&timezone=#{Rack::Utils.escape(timezone)}"\
      "&start_date=#{today_date.strftime('%Y-%m-%d')}"\
      "&end_date=#{to_date.strftime('%Y-%m-%d')}"
  end

  def to_date
    today_date.advance(days: 7)
  end
end

# RSpec.describe WeatherData do
#   subject(:weather_fetcher) { WeatherData.new(57.2, 49.0) }
  
#   it 'fetches weather bargle' do
#     # do whatever
#   end
# end
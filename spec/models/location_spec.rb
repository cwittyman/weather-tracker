require 'rails_helper'

RSpec.describe Location, type: :model do
  
  let(:test_weather_data) do 
   {
      "current_weather" => {
        "temperature" => 30.4,
        "weathercode" => 0,
        "time" => "2022-12-04T22:00"
      },
      "hourly" => {
        "time" => [ "2022-11-27T00:00", "2022-11-27T01:00", "2022-11-27T02:00"],
        "temperature_2m" => [46.4,47.2,47.2],
        "weathercode" => [0,0,0]
      },
      "daily" => {
        "time" => ["2022-11-27","2022-11-28"],
        "weathercode" => [0,0],
        "temperature_2m_max" => [61.5,51.6],
        "temperature_2m_min" => [45.3,41],
        "sunrise" => ["2022-11-27T07:11","2022-11-28T07:12"],
        "sunset" => ["2022-11-27T17:07","2022-11-28T17:06"]
      }
    }
  end

  describe "Validate" do
    subject(:location) { create(:location) }
    it "is valid with valid attributes" do
      expect(location).to be_valid
    end

    it "is not valid without name" do
      location.name = nil
      expect(location).to_not be_valid
    end

    it "is not valid without latitude" do
      location.lat = nil
      expect(location).to_not be_valid
    end

    it "is not valid without longitude" do
      location.lng = nil
      expect(location).to_not be_valid
    end

    it "is not valid without timezone" do
      location.timezone = nil
      expect(location).to_not be_valid
    end

    it "is is_selected truthy" do
      expect(location.is_selected).to be(true)
    end
  end
  
  describe "Create Weather Data" do
    subject(:location) { create(:location) }
    before do
      # location.stub :weather_data => test_weather_data
    end

    it "should call weather data" do
      expect(location).to receive(:weather_data).at_least(3).and_return(test_weather_data)
      # allow(location).to receive(:create_daily_data)
      location.create_daily_data
      # expect(location).to have_received(:create_daily_data)
    end

    it "should have forecasts" do
      expect(location).to receive(:weather_data).at_least(:once).and_return(test_weather_data)
      location.create_daily_data
      expect(location.forecasts.count).to eq(6)
    end

    it "should create current weather data" do
      
    end

  end

end

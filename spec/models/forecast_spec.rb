require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe "attributes" do
    subject(:forecast) { create(:forecast) }

    it "is valid with valid attributes" do
      expect(forecast).to be_valid
    end
  end

  describe "Create" do
    subject(:location) { create(:location) }
    subject(:forecast) { create(:forecast) }

    #create_list(:forecast, 2, location: location, type: "HourlyForecast")
    it "should have 2 forecasts" do
      create_list(:forecast, 2, location: location) do |record, i|
        record.type = "HourlyForecast"
        record.temp = rand(10...80)
        record.save!
      end
      
      expect(location.forecasts.count).to eq(2)
      expect(location.forecasts.where(type:"HourlyForecast").count).to eq(2)
    end
  end
end

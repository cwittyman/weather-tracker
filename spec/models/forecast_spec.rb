require 'rails_helper'

RSpec.describe Forecast, type: :model do
  before(:all) do
    @forecast = create(:forecast)
  end

  after(:all) do
    @location = @forecast.location
    @forecast.destroy!
    @location.destroy!
  end

  it "is valid with valid attributes" do
    expect(@forecast).to be_valid
  end
end

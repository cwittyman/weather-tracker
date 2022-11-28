RSpec.describe "Current Forecasts Page", :type => :system do
    before(:all) do
        @existing_location = create(:location, name: "Test Current Town")
        @existing_location.save!
        1.times do |i|
            @forecast = Forecast.create(
                temp: "#{rand(10...99)}", 
                time_taken: Time.now.utc,
                location_id: @existing_location.id,
                type: "CurrentForecast",
                timezone: "America/New_York",
                code: "1" 
            )
        end
        50.times do |i|
            @forecast = Forecast.create(
                temp: "#{rand(10...99)}", 
                time_taken: Time.now.utc + i.day,
                location_id: @existing_location.id,
                timezone: "America/New_York",
                code: "1" 
            )
            @forecast.save!
        end
    end
    before do
      #driven_by(:selenium, using: :headless_chrome, screen_size: [1400, 1400])
      driven_by(:selenium)
    end
  
    it "Current Forecast" do
        visit "/forecasts#index"
        expect(page).to have_text(@existing_location.name)
    end
  end
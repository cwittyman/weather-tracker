RSpec.describe "Hourly Forecasts Page", :type => :system do

    before do
      #driven_by(:selenium, using: :headless_chrome, screen_size: [1400, 1400])
      driven_by(:selenium)
    end
  
    it "Hourly Forecast" do
        visit "/hourlyforecasts#index"
        sleep 5.to_i
    end
  end
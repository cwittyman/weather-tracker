RSpec.describe "Workflow end to end", :type => :system do
    before(:all) do
      @existing_location = create(:location)
      @new_location_name = "Knoxville, Tennessee"
      @search_term = "Knoxville"
    end
    before do
      #driven_by(:selenium, using: :headless_chrome, screen_size: [1400, 1400])
      driven_by(:selenium)
    end
  
    it "Add City" do
      visit "/locations#index"
      fill_in "autocomplete-input", :with => @search_term
  
      #TODO find a better way todo this
      sleep 1.to_i
      page.execute_script('$(".dropdown-content li").eq(0).trigger("click")')
      sleep 5.to_i
  
      expect(page).to have_text(@full_name)
    end

    it "Check Current" do
        visit "/forecasts#index"
    
        expect(page).to have_text(@new_location_name)
        page.should have_css('#forecasts img')
    end

    it "Check Hourly" do
        visit "/hourlyforecasts#index"
    
        expect(page).to have_text(@new_location_name)
        page.should have_css('#hourlyforecasts img')
    end
    
    it "Check Daily" do
        visit "/dailyforecasts#index"
    
        expect(page).to have_text(@new_location_name)
        page.should have_css('#dailyforecasts img')
    end

    it "Delete City" do
      visit "/locations#index"
      
      first("ul li button").click
  
    end
  
  end
RSpec.describe "Locations Page", :type => :system do
  before do
    #driven_by(:selenium, using: :headless_chrome, screen_size: [1400, 1400])
    driven_by(:selenium)
  end

  it "Search City" do
    visit "/locations#index"
    fill_in "autocomplete-input", :with => "Blacksburg"

    expect(page).to have_text("Blacksburg")
  end
end
require 'rails_helper'

RSpec.describe Location, type: :model do
  before(:all) do
    @location = create(:location)
  end

  after(:all) do
    @location.destroy!
  end

  it "is valid with valid attributes" do
    expect(@location).to be_valid
  end

end

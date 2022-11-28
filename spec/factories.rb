FactoryBot.define do
    factory :location do
        name { "Roanoke, Virginia - #{rand(10...42)}" }
        lat { "37.27" }
        lng { "-79.94" }
        timezone { "America/New_York" }
        location_id { 4782167 }
    end

    factory :forecast do
        temp { "46.4" }
        time_taken { "2022-11-27T00:00" }
        location { association :location }
    end
end
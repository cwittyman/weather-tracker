# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_23_214344) do
  create_table "forecasts", force: :cascade do |t|
    t.string "temp"
    t.string "mintemp"
    t.string "maxtemp"
    t.integer "code"
    t.datetime "time_taken"
    t.datetime "sunrise"
    t.datetime "sunset"
    t.string "timezone"
    t.string "utc_offset"
    t.string "type", default: "HourlyForecast", null: false
    t.integer "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_forecasts_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "lat"
    t.string "lng"
    t.string "timezone"
    t.boolean "is_selected", default: true
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "forecasts", "locations"
end

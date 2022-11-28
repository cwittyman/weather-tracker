class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.string :temp, null: true
      t.string :mintemp, null: true
      t.string :maxtemp, null: true
      t.integer :code
      t.datetime :time_taken
      t.datetime :sunrise
      t.datetime :sunset
      t.string :timezone
      t.string :utc_offset
      t.string :type, null: false, default: 'HourlyForecast'
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end

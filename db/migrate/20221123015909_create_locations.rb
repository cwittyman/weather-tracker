class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :lat
      t.string :lng
      t.string :timezone
      t.boolean :is_selected, default: 'true'
      t.integer :location_id, null: true

      t.timestamps
    end
  end
end

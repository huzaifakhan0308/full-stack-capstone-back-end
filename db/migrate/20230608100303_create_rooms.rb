class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.string :description
      t.string :wifi
      t.string :tv
      t.string :room_service
      t.integer :beds
      t.string :image_url
      t.string :reserved
      t.string :boolean
      t.references :users, null: false, foreign_key: true

      t.timestamps
    end
  end
end

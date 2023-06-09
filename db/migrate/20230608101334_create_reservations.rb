class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.date :from_date
      t.date :to_date
      t.references :users, null: false, foreign_key: true
      t.references :rooms, null: false, foreign_key: true

      t.timestamps
    end
  end
end
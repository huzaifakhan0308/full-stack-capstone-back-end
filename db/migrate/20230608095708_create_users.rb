class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.integer :rooms_count, default: 0

      t.timestamps
    end
  end
end

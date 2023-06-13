class AddForeignReferences < ActiveRecord::Migration[7.0]
  def change
    add_reference :rooms, :reservations, foreign_key: true
  end
end

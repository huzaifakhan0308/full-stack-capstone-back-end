class AddForeignReferences < ActiveRecord::Migration[7.0]
  def change
    add_reference :rooms, :reservations, foreign_key: { to_table: :reservations, on_delete: :cascade }
  end
end

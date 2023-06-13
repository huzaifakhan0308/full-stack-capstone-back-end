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

ActiveRecord::Schema[7.0].define(version: 2023_06_10_230056) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.date "date"
    t.string "city"
    t.bigint "users_id", null: false
    t.bigint "rooms_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rooms_id"], name: "index_reservations_on_rooms_id"
    t.index ["users_id"], name: "index_reservations_on_users_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_name"
    t.string "description"
    t.string "wifi"
    t.string "tv"
    t.string "room_service"
    t.integer "beds"
    t.string "image_url"
    t.bigint "users_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reservations_id"
    t.index ["reservations_id"], name: "index_rooms_on_reservations_id"
    t.index ["users_id"], name: "index_rooms_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.integer "rooms_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "reservations", "rooms", column: "rooms_id"
  add_foreign_key "reservations", "users", column: "users_id"
  add_foreign_key "rooms", "reservations", column: "reservations_id"
  add_foreign_key "rooms", "users", column: "users_id"
end

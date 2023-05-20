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

ActiveRecord::Schema[7.0].define(version: 2023_05_20_163214) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commissions", force: :cascade do |t|
    t.string "kind"
    t.decimal "price"
    t.string "duration"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "artist_id"
    t.integer "client_id"
    t.integer "request_id"
    t.jsonb "process", array: true
  end

  create_table "requests", force: :cascade do |t|
    t.string "kind"
    t.decimal "price"
    t.string "duration"
    t.string "status", default: "pending"
    t.string "payment_status", default: "unpaid"
    t.integer "client_id"
    t.integer "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.string "token"
    t.string "role"
    t.boolean "email_confirmed", default: false
    t.string "password_reset_token"
    t.integer "verification_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

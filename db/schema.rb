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

ActiveRecord::Schema.define(version: 2021_12_28_014641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password"
    t.string "password_confirmation"
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "markets", force: :cascade do |t|
    t.string "stock_name"
    t.float "price_per_unit"
    t.string "percentage_change"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "symbol"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "stock_name"
    t.integer "shares"
    t.float "price_per_unit"
    t.float "total_price"
    t.bigint "trader_id"
    t.bigint "market_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "symbol"
    t.index ["market_id"], name: "index_stocks_on_market_id"
    t.index ["trader_id"], name: "index_stocks_on_trader_id"
  end

  create_table "traders", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password"
    t.string "password_confirmation"
    t.float "wallet"
    t.index ["user_id"], name: "index_traders_on_user_id"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.string "stock_name"
    t.integer "shares"
    t.float "price_per_unit"
    t.float "total_price"
    t.float "balance"
    t.bigint "trader_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "transaction_type"
    t.string "symbol"
    t.float "total_shares"
    t.index ["trader_id"], name: "index_transaction_histories_on_trader_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.string "user_type"
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "admins", "users"
  add_foreign_key "traders", "users"
end

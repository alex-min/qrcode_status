# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160429111321) do

  create_table "client_events", force: :cascade do |t|
    t.string   "event_name"
    t.text     "comment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "client_id"
    t.string   "event_code"
    t.boolean  "sms_sent"
    t.text     "message"
    t.boolean  "last_message"
    t.boolean  "show_on_list"
  end

  add_index "client_events", ["client_id"], name: "index_client_events_on_client_id"

  create_table "clients", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "postal_code"
    t.string   "city"
    t.string   "phone"
    t.text     "panne"
    t.string   "product"
    t.string   "brand"
    t.string   "product_name"
    t.string   "etat"
    t.string   "product_state"
    t.string   "unique_id"
    t.integer  "user_id"
    t.boolean  "processed",     default: false
    t.integer  "company_id"
  end

  add_index "clients", ["company_id"], name: "index_clients_on_company_id"
  add_index "clients", ["user_id"], name: "index_clients_on_user_id"

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "website"
  end

  create_table "user_messages", force: :cascade do |t|
    t.string   "code"
    t.string   "title"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "action"
  end

  add_index "user_messages", ["user_id"], name: "index_user_messages_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "twillo_account_sid"
    t.string   "twillo_auth_token"
    t.string   "twillo_root_phone"
    t.integer  "company_id"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

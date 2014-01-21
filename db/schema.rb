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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140121205011) do

  create_table "addresses", :force => true do |t|
    t.integer  "wedding_id"
    t.string   "address_type"
    t.string   "name"
    t.string   "line_1"
    t.string   "line_2"
    t.string   "post_code"
    t.string   "map_ref"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "addresses", ["wedding_id"], :name => "index_addresses_on_wedding_id"

  create_table "details", :force => true do |t|
    t.integer  "wedding_id"
    t.text     "text"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "image"
    t.string   "page_name"
    t.integer  "order"
    t.string   "formatting_class"
    t.string   "image_size"
  end

  create_table "gifts", :force => true do |t|
    t.integer  "wedding_id"
    t.string   "name"
    t.string   "code"
    t.string   "link"
    t.float    "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "gifts", ["wedding_id"], :name => "index_gifts_on_wedding_id"

  create_table "guest_lists", :force => true do |t|
    t.string   "name"
    t.integer  "wedding_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  add_index "guest_lists", ["wedding_id"], :name => "index_guest_owners_on_wedding_id"

  create_table "guest_permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "guest_id"
    t.integer  "list_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "status"
    t.integer  "wedding_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "seats"
    t.integer  "guest_list_id"
  end

  add_index "guests", ["wedding_id"], :name => "index_guests_on_wedding_id"

  create_table "rsvps", :force => true do |t|
    t.integer  "wedding_id"
    t.string   "name"
    t.string   "email"
    t.boolean  "attendance"
    t.string   "dietary"
    t.string   "message"
    t.integer  "linked_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "bus_required"
  end

  add_index "rsvps", ["linked_id"], :name => "index_rsvps_on_linked_id"
  add_index "rsvps", ["wedding_id"], :name => "index_rsvps_on_wedding_id"

  create_table "users", :force => true do |t|
    t.string   "nickname",               :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "authentication_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "weddings", :force => true do |t|
    t.string   "bride"
    t.string   "groom"
    t.date     "on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "image"
    t.string   "name"
    t.string   "groom_email"
    t.string   "bride_email"
    t.string   "param_name"
  end

end

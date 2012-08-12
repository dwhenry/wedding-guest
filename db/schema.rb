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

ActiveRecord::Schema.define(:version => 20120812210259) do

  create_table "guest_owners", :force => true do |t|
    t.string   "name"
    t.integer  "wedding_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guest_owners", ["wedding_id"], :name => "index_guest_owners_on_wedding_id"

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "status"
    t.integer  "wedding_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seats"
    t.string   "owner"
    t.integer  "guest_owner_id"
  end

  add_index "guests", ["wedding_id"], :name => "index_guests_on_wedding_id"

  create_table "weddings", :force => true do |t|
    t.string   "bride"
    t.string   "groom"
    t.date     "on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "name"
  end

end

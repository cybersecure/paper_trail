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

ActiveRecord::Schema.define(:version => 20110208155312) do

  create_table "articles", :force => true do |t|
    t.string "title",       :limit => 50
    t.string "content",     :limit => 50
    t.string "abstract",    :limit => 50
    t.string "file_upload", :limit => 50
  end

  create_table "documents", :force => true do |t|
    t.string "name", :limit => 50
  end

  create_table "paper_trail_model_data_mapper_versions", :force => true do |t|
    t.integer   "item_id",                      :null => false
    t.string    "item_type",      :limit => 50, :null => false
    t.string    "event",          :limit => 50, :null => false
    t.string    "whodunnit",      :limit => 50, :null => false
    t.text      "object"
    t.text      "object_changes"
    t.timestamp "created_at"
  end

  create_table "post_versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "ip"
    t.string   "user_agent"
  end

  create_table "posts", :force => true do |t|
    t.string "title",   :limit => 50
    t.string "content", :limit => 50
  end

  create_table "songs", :force => true do |t|
    t.integer "length"
  end

  create_table "translations", :force => true do |t|
    t.string "headline",      :limit => 50
    t.string "content",       :limit => 50
    t.string "language_code", :limit => 50
    t.string "type",          :limit => 50
  end

end

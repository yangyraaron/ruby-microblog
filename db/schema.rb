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

ActiveRecord::Schema.define(:version => 20130628133552) do

  create_table "attachments", :id => false, :force => true do |t|
    t.integer  "id",         :limit => 8, :null => false
    t.string   "name"
    t.string   "path"
    t.string   "ext"
    t.string   "mime"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "comments", :id => false, :force => true do |t|
    t.integer  "id",               :limit => 8, :null => false
    t.string   "content"
    t.integer  "creator_id",       :limit => 8
    t.integer  "feed_id",          :limit => 8, :null => false
    t.integer  "reply_comment_id", :limit => 8
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "comments", ["feed_id"], :name => "index_comments_on_feed_id"

  create_table "fans", :id => false, :force => true do |t|
    t.integer  "id",         :limit => 8, :null => false
    t.integer  "user_id",    :limit => 8, :null => false
    t.integer  "fans_id",    :limit => 8, :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "fans", ["fans_id"], :name => "index_fans_on_fans_id"
  add_index "fans", ["user_id"], :name => "index_fans_on_user_id"

  create_table "feeds", :id => false, :force => true do |t|
    t.integer  "id",             :limit => 8, :null => false
    t.string   "content"
    t.integer  "creator_id",     :limit => 8
    t.integer  "attach_id",      :limit => 8
    t.integer  "origin_feed_id", :limit => 8
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "forward_count"
    t.integer  "comment_count"
  end

  add_index "feeds", ["creator_id"], :name => "index_feeds_on_creator_id"

  create_table "follows", :id => false, :force => true do |t|
    t.integer  "id",           :limit => 8, :null => false
    t.integer  "user_id",      :limit => 8, :null => false
    t.integer  "following_id", :limit => 8, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "follows", ["following_id"], :name => "index_follows_on_following_id"
  add_index "follows", ["user_id"], :name => "index_follows_on_user_id"

  create_table "groups", :id => false, :force => true do |t|
    t.integer  "id",          :limit => 8, :null => false
    t.string   "name",                     :null => false
    t.string   "description"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "creator_id",  :limit => 8
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id", :limit => 8, :null => false
    t.integer "user_id",  :limit => 8, :null => false
  end

  add_index "groups_users", ["group_id"], :name => "index_groups_users_on_group_id"
  add_index "groups_users", ["user_id"], :name => "index_groups_users_on_user_id"

  create_table "users", :id => false, :force => true do |t|
    t.integer  "user_id",         :limit => 8, :null => false
    t.string   "account",                      :null => false
    t.string   "hashed_password",              :null => false
    t.string   "email",                        :null => false
    t.string   "dynamic_desc"
    t.integer  "image_id",        :limit => 8
    t.integer  "msg_count",       :limit => 8
    t.integer  "fans_count"
    t.integer  "following_count"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "salt"
    t.string   "password"
  end

  add_index "users", ["account"], :name => "index_users_on_account", :unique => true

end

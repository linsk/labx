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

ActiveRecord::Schema.define(:version => 20130420174750) do

  create_table "logs", :force => true do |t|
    t.string   "where"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "nick"
    t.string   "email"
    t.string   "website"
    t.string   "city"
    t.string   "slogan"
    t.date     "jointime"
    t.string   "qq"
    t.string   "phonecall"
    t.string   "weibo"
    t.date     "birthday"
    t.string   "constellation"
    t.string   "twitter"
    t.string   "weixin"
    t.string   "github"
    t.string   "name"
    t.string   "dribbble"
    t.string   "avatar"
    t.date     "graduation"
    t.string   "role"
    t.text     "introduce"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end

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

ActiveRecord::Schema.define(version: 20150603070146) do

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name",       null: false
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"
  add_index "players", ["name", "game_id"], name: "index_players_on_name_and_game_id", unique: true

  create_table "players_quests", id: false, force: true do |t|
    t.integer "quest_id",  null: false
    t.integer "player_id", null: false
  end

  create_table "quests", force: true do |t|
    t.integer  "num_fails"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quests", ["game_id"], name: "index_quests_on_game_id"

end

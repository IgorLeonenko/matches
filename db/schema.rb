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

ActiveRecord::Schema.define(version: 20161005163430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_games_on_name", unique: true, using: :btree
  end

  create_table "matches", force: :cascade do |t|
    t.string   "status",             default: "prepare",  null: false
    t.string   "style",              default: "friendly", null: false
    t.integer  "home_team_id",                            null: false
    t.integer  "invited_team_id",                         null: false
    t.integer  "home_team_score",    default: 0,          null: false
    t.integer  "invited_team_score", default: 0,          null: false
    t.integer  "game_id",                                 null: false
    t.integer  "round_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["game_id"], name: "index_matches_on_game_id", using: :btree
    t.index ["home_team_id"], name: "index_matches_on_home_team_id", using: :btree
    t.index ["invited_team_id"], name: "index_matches_on_invited_team_id", using: :btree
    t.index ["round_id"], name: "index_matches_on_round_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "number"
    t.integer  "tournament_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id", using: :btree
  end

  create_table "team_users", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.index ["team_id", "user_id"], name: "index_team_users_on_team_id_and_user_id", unique: true, using: :btree
    t.index ["team_id"], name: "index_team_users_on_team_id", using: :btree
    t.index ["user_id"], name: "index_team_users_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "tournament_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id"], name: "index_teams_on_tournament_id", using: :btree
  end

  create_table "tournament_users", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id", "user_id"], name: "index_tournament_users_on_tournament_id_and_user_id", unique: true, using: :btree
    t.index ["tournament_id"], name: "index_tournament_users_on_tournament_id", using: :btree
    t.index ["user_id"], name: "index_tournament_users_on_user_id", using: :btree
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "title",                                           null: false
    t.text     "description"
    t.datetime "start_date",      default: '2016-10-06 00:00:00', null: false
    t.string   "picture"
    t.string   "style",           default: "league",              null: false
    t.string   "state",           default: "open",                null: false
    t.integer  "teams_quantity",  default: 0,                     null: false
    t.integer  "players_in_team"
    t.integer  "creator_id"
    t.integer  "game_id",                                         null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["game_id"], name: "index_tournaments_on_game_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.string   "password_digest",                 null: false
    t.string   "username",                        null: false
    t.string   "avatar"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "tournament_users", "tournaments"
  add_foreign_key "tournament_users", "users"
  add_foreign_key "tournaments", "games"
end

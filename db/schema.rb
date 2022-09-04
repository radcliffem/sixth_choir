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

ActiveRecord::Schema.define(version: 20220901173455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "appearances", force: true do |t|
    t.date     "date"
    t.integer  "payment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "soloist_id"
  end

  add_index "appearances", ["soloist_id"], name: "index_appearances_on_soloist_id", using: :btree

  create_table "appearances_performances", id: false, force: true do |t|
    t.integer "appearance_id",  null: false
    t.integer "performance_id", null: false
  end

  add_index "appearances_performances", ["appearance_id"], name: "index_appearances_performances_on_appearance_id", using: :btree
  add_index "appearances_performances", ["performance_id"], name: "index_appearances_performances_on_performance_id", using: :btree

  create_table "appearances_soloists", id: false, force: true do |t|
    t.integer "appearance_id", null: false
    t.integer "soloist_id",    null: false
  end

  add_index "appearances_soloists", ["appearance_id", "soloist_id"], name: "index_appearances_soloists_on_appearance_id_and_soloist_id", using: :btree
  add_index "appearances_soloists", ["soloist_id", "appearance_id"], name: "index_appearances_soloists_on_soloist_id_and_appearance_id", using: :btree

  create_table "arrangers", force: true do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "display_name"
  end

  create_table "arrangers_pieces", id: false, force: true do |t|
    t.integer "arranger_id", null: false
    t.integer "piece_id",    null: false
  end

  add_index "arrangers_pieces", ["arranger_id", "piece_id"], name: "index_arrangers_pieces_on_arranger_id_and_piece_id", using: :btree
  add_index "arrangers_pieces", ["piece_id", "arranger_id"], name: "index_arrangers_pieces_on_piece_id_and_arranger_id", using: :btree

  create_table "collections", force: true do |t|
    t.string "name"
  end

  create_table "collections_pieces", id: false, force: true do |t|
    t.integer "collection_id", null: false
    t.integer "piece_id",      null: false
  end

  add_index "collections_pieces", ["collection_id", "piece_id"], name: "index_collections_pieces_on_collection_id_and_piece_id", using: :btree
  add_index "collections_pieces", ["piece_id", "collection_id"], name: "index_collections_pieces_on_piece_id_and_collection_id", using: :btree

  create_table "composers", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "nationality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "composers_pieces", id: false, force: true do |t|
    t.integer "composer_id", null: false
    t.integer "piece_id",    null: false
  end

  add_index "composers_pieces", ["composer_id", "piece_id"], name: "index_composers_pieces_on_composer_id_and_piece_id", using: :btree
  add_index "composers_pieces", ["piece_id", "composer_id"], name: "index_composers_pieces_on_piece_id_and_composer_id", using: :btree

  create_table "performances", force: true do |t|
    t.string   "purpose"
    t.integer  "piece_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "acapella"
    t.string   "voice"
    t.integer  "season_id"
    t.string   "service_type"
    t.date     "date"
  end

  create_table "performances_pieces", id: false, force: true do |t|
    t.integer "performance_id", null: false
    t.integer "piece_id",       null: false
  end

  add_index "performances_pieces", ["performance_id"], name: "index_performances_pieces_on_performance_id", using: :btree
  add_index "performances_pieces", ["piece_id"], name: "index_performances_pieces_on_piece_id", using: :btree

  create_table "performances_seasons", id: false, force: true do |t|
    t.integer "season_id",      null: false
    t.integer "performance_id", null: false
  end

  add_index "performances_seasons", ["performance_id", "season_id"], name: "index_performances_seasons_on_performance_id_and_season_id", using: :btree
  add_index "performances_seasons", ["season_id", "performance_id"], name: "index_performances_seasons_on_season_id_and_performance_id", using: :btree

  create_table "pieces", force: true do |t|
    t.string   "title"
    t.integer  "year"
    t.string   "genre"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_number"
    t.string   "publisher"
    t.string   "catalog_number"
    t.boolean  "acapella"
    t.string   "voices",         default: [], array: true
    t.string   "special_parts",  default: [], array: true
    t.text     "notes"
    t.integer  "collection_id"
  end

  add_index "pieces", ["collection_id"], name: "index_pieces_on_collection_id", using: :btree

  create_table "pieces_seasons", id: false, force: true do |t|
    t.integer "season_id", null: false
    t.integer "piece_id",  null: false
  end

  add_index "pieces_seasons", ["piece_id", "season_id"], name: "index_pieces_seasons_on_piece_id_and_season_id", using: :btree
  add_index "pieces_seasons", ["season_id", "piece_id"], name: "index_pieces_seasons_on_season_id_and_piece_id", using: :btree

  create_table "seasons", force: true do |t|
    t.string "liturgical_season"
  end

  create_table "soloists", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "instrument"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

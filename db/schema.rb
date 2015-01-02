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

ActiveRecord::Schema.define(version: 20141228021113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apis", force: :cascade do |t|
    t.string   "name",                          null: false
    t.string   "install_url",                   null: false
    t.string   "uninstall_url",                 null: false
    t.boolean  "is_active",     default: false
    t.integer  "account_id",                    null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "data_encodings", force: :cascade do |t|
    t.string   "name",             null: false
    t.string   "token",            null: false
    t.integer  "installed_api_id", null: false
    t.integer  "account_id",       null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "encoded_fields", force: :cascade do |t|
    t.string   "name",                null: false
    t.integer  "field_id",            null: false
    t.integer  "encoded_resource_id", null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "encoded_resources", force: :cascade do |t|
    t.string   "name",             null: false
    t.integer  "data_encoding_id", null: false
    t.integer  "resource_id",      null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "type"
    t.string   "dpath"
    t.boolean  "is_required",     default: false
    t.boolean  "used_for_search", default: false
    t.boolean  "is_scope",        default: false
    t.integer  "resource_id",                     null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "installed_apis", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "token",                      null: false
    t.boolean  "is_dev",     default: false
    t.integer  "api_id",                     null: false
    t.integer  "account_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.json     "criteria",                             null: false
    t.string   "status",           default: "working"
    t.string   "type"
    t.integer  "data_encoding_id",                     null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "customs_url"
    t.string   "search_url"
    t.string   "created_url"
    t.string   "updated_url"
    t.string   "read_url"
    t.string   "create_url"
    t.string   "update_url"
    t.string   "delete_url"
    t.integer  "api_id",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",      null: false
    t.string   "last_name",       null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "last_signin_at"
    t.integer  "account_id",      null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end

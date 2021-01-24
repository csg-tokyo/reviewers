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

ActiveRecord::Schema.define(version: 20180624065937) do

  create_table "actionlogs", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_actionlogs_on_article_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.integer  "article_type"
    t.integer  "category"
    t.integer  "pages"
    t.integer  "decision"
    t.integer  "volume"
    t.integer  "number"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "memo"
    t.string   "name"
    t.boolean  "is_letter"
    t.text     "abstract"
    t.text     "contact"
    t.boolean  "done",              default: false
    t.boolean  "approved",          default: false
    t.text     "article_type_name"
    t.text     "etitle"
    t.boolean  "member",            default: true
    t.integer  "position"
    t.text     "ethics"
  end

  create_table "authors", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "affiliation"
    t.integer  "article_id"
    t.index ["article_id"], name: "index_authors_on_article_id"
  end

  create_table "conflicts", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_conflicts_on_article_id"
    t.index ["user_id"], name: "index_conflicts_on_user_id"
  end

  create_table "editors", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_editors_on_article_id"
    t.index ["user_id"], name: "index_editors_on_user_id"
  end

  create_table "reviewers", force: :cascade do |t|
    t.integer  "article_id"
    t.string   "name"
    t.string   "affiliation"
    t.string   "email"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["article_id"], name: "index_reviewers_on_article_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "kind"
    t.integer  "decision"
    t.boolean  "award"
    t.text     "to_editor"
    t.text     "to_author"
    t.text     "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_reviews_on_article_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "kind"
    t.binary   "file"
    t.text     "memo"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "content_type"
    t.string   "file_path"
    t.index ["article_id"], name: "index_submissions_on_article_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "admin"
    t.boolean  "active",          default: true
    t.string   "affiliation"
    t.boolean  "guest_editor"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end

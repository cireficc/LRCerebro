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

ActiveRecord::Schema.define(version: 20170509175509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_configurations", force: :cascade do |t|
    t.text     "enrollment_update_message"
    t.datetime "enrollment_last_updated"
    t.datetime "current_semester_start"
    t.datetime "current_semester_end"
    t.datetime "class_project_submission_start"
    t.datetime "class_project_submission_end"
    t.text     "class_project_before_deadline_message"
    t.text     "class_project_after_deadline_message"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "current_semester_year"
    t.integer  "current_semester"
  end

  create_table "cds", force: :cascade do |t|
    t.integer  "language"
    t.string   "artist"
    t.string   "album"
    t.integer  "year"
    t.text     "tracks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer  "year"
    t.integer  "semester"
    t.integer  "department"
    t.integer  "course"
    t.integer  "section"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "digitized_versions", force: :cascade do |t|
    t.integer  "film_id"
    t.string   "audio_language"
    t.string   "subtitle_language"
    t.string   "direct_link"
    t.text     "embed_code"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "english_title"
    t.string   "foreign_title"
  end

  create_table "enrollments", force: :cascade do |t|
    t.string   "user_id",    null: false
    t.integer  "course_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
  end

  add_index "enrollments", ["course_id", "user_id"], name: "index_enrollments_on_course_id_and_user_id", using: :btree
  add_index "enrollments", ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", using: :btree

  create_table "equipment", force: :cascade do |t|
    t.integer  "equipment_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "films", force: :cascade do |t|
    t.integer  "film_type"
    t.string   "english_title"
    t.string   "foreign_title"
    t.string   "transliterated_foreign_title"
    t.text     "description"
    t.text     "audio_languages",              default: [],              array: true
    t.text     "subtitle_languages",           default: [],              array: true
    t.integer  "year"
    t.integer  "length"
    t.integer  "mpaa_rating"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "cover"
    t.string   "more_info_link"
  end

  create_table "games", force: :cascade do |t|
    t.string   "english_title"
    t.string   "foreign_title"
    t.text     "audio_languages",    default: [],              array: true
    t.text     "subtitle_languages", default: [],              array: true
    t.integer  "platform"
    t.integer  "year"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "inventory_items", force: :cascade do |t|
    t.string   "catalog_number"
    t.string   "catalog_code"
    t.integer  "status"
    t.text     "status_description"
    t.text     "notes"
    t.integer  "inventoriable_id"
    t.string   "inventoriable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "inventory_items", ["inventoriable_id", "inventoriable_type"], name: "inventory_items_polymorphic_association_index", using: :btree

  create_table "project_reservations", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "category"
    t.datetime "start"
    t.datetime "end"
    t.integer  "lab",                       default: 1
    t.integer  "subtype"
    t.text     "staff_notes"
    t.text     "faculty_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google_calendar_event_id"
    t.string   "google_calendar_html_link"
    t.boolean  "mini_project"
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "name"
    t.text     "description"
    t.integer  "category"
    t.integer  "group_size"
    t.datetime "script_due"
    t.datetime "due"
    t.datetime "viewable_by"
    t.boolean  "approved",                         default: false
    t.string   "publish_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google_calendar_publish_event_id"
  end

  create_table "standard_reservations", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "activity"
    t.datetime "start"
    t.datetime "end"
    t.integer  "lab"
    t.boolean  "walkthrough"
    t.text     "utilities",                 default: [], array: true
    t.text     "assistances",               default: [], array: true
    t.text     "additional_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google_calendar_event_id"
    t.string   "google_calendar_html_link"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tests", force: :cascade do |t|
    t.string   "string_enum"
    t.string   "string_enum_other"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "pitm"
    t.string   "encrypted_password", default: "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.boolean  "registered"
  end

end

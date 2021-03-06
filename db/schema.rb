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

ActiveRecord::Schema.define(version: 2018_07_10_151209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_configurations", id: :serial, force: :cascade do |t|
    t.text "enrollment_update_message"
    t.datetime "enrollment_last_updated"
    t.datetime "current_semester_start"
    t.datetime "current_semester_end"
    t.datetime "class_project_submission_start"
    t.datetime "class_project_submission_end"
    t.text "class_project_before_deadline_message"
    t.text "class_project_after_deadline_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_semester_year"
    t.integer "current_semester"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.integer "year"
    t.integer "semester"
    t.integer "department"
    t.integer "course"
    t.integer "section"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "digitized_versions", id: :serial, force: :cascade do |t|
    t.integer "film_id"
    t.string "audio_language"
    t.string "subtitle_language"
    t.string "direct_link"
    t.text "embed_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "english_title"
    t.string "foreign_title"
  end

  create_table "enrollments", id: :serial, force: :cascade do |t|
    t.string "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "role"
    t.index ["course_id", "user_id"], name: "index_enrollments_on_course_id_and_user_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id"
  end

  create_table "film_digitizations", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "film_id"
    t.datetime "due_date"
    t.string "media_source"
    t.string "film_title"
    t.string "audio_language"
    t.string "subtitle_language"
    t.text "additional_instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "films", id: :serial, force: :cascade do |t|
    t.integer "film_type"
    t.string "english_title"
    t.string "foreign_title"
    t.string "transliterated_foreign_title"
    t.text "description"
    t.text "audio_languages", default: [], array: true
    t.text "subtitle_languages", default: [], array: true
    t.integer "year"
    t.integer "length"
    t.integer "mpaa_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover"
    t.string "more_info_link"
    t.string "catalog_number"
  end

  create_table "mini_projects", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.text "resources", default: [], array: true
    t.text "description"
    t.boolean "supplemental_materials"
    t.datetime "start_date"
    t.datetime "due_date"
    t.datetime "publish_by"
    t.text "publish_methods", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "google_calendar_publish_event_id"
    t.text "supplemental_materials_description"
  end

  create_table "project_reservations", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "category"
    t.datetime "start"
    t.datetime "end"
    t.integer "lab", default: 1
    t.integer "subtype"
    t.text "staff_notes"
    t.text "faculty_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "google_calendar_event_id"
    t.string "google_calendar_html_link"
    t.boolean "mini_project"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.string "name"
    t.text "description"
    t.string "category"
    t.integer "group_size"
    t.datetime "script_due"
    t.datetime "due"
    t.datetime "publish_by"
    t.boolean "approved", default: false
    t.string "publish_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "google_calendar_publish_event_id"
    t.text "publish_methods", default: [], array: true
  end

  create_table "standard_reservations", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.string "activity"
    t.datetime "start"
    t.datetime "end"
    t.integer "lab"
    t.boolean "walkthrough"
    t.text "utilities", default: [], array: true
    t.text "assistances", default: [], array: true
    t.text "additional_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "google_calendar_event_id"
    t.string "google_calendar_html_link"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "pitm"
    t.string "encrypted_password", default: "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "role"
    t.boolean "registered"
  end

  create_table "vidcams", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.string "location"
    t.datetime "start"
    t.datetime "end"
    t.datetime "publish_by"
    t.boolean "upload_to_ensemble"
    t.text "publish_methods", default: [], array: true
    t.text "additional_instructions"
    t.string "google_calendar_filming_event_id"
    t.string "google_calendar_publishing_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "works", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.datetime "due_date"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

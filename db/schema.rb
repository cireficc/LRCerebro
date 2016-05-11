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

ActiveRecord::Schema.define(version: 20160511212132) do

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

  create_table "enrollments", force: :cascade do |t|
    t.string   "user_id",    null: false
    t.integer  "course_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollments", ["course_id", "user_id"], name: "index_enrollments_on_course_id_and_user_id", using: :btree
  add_index "enrollments", ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", using: :btree

  create_table "project_reservations", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "category"
    t.datetime "start"
    t.datetime "end"
    t.integer  "lab"
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
    t.integer  "num_groups"
    t.datetime "script_due"
    t.datetime "due"
    t.datetime "viewable_by"
    t.boolean  "approved",     default: false
    t.string   "publish_link"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "g_number"
    t.string   "password_digest", default: "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.boolean  "registered"
  end

end

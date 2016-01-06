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

ActiveRecord::Schema.define(version: 20160105233243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: true do |t|
    t.integer "year"
    t.integer "semester"
    t.integer "department"
    t.integer "course"
    t.integer "section"
    t.string  "name"
  end

  create_table "enrollments", id: false, force: true do |t|
    t.integer "user_id",   null: false
    t.integer "course_id", null: false
  end

  add_index "enrollments", ["course_id", "user_id"], name: "index_enrollments_on_course_id_and_user_id", using: :btree
  add_index "enrollments", ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", using: :btree

  create_table "project_reservations", force: true do |t|
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
  end

  create_table "projects", force: true do |t|
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
    t.boolean  "archived",     default: false
    t.datetime "archived_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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

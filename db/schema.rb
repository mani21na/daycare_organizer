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

ActiveRecord::Schema.define(version: 8) do

  create_table "daycares", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.text "address"
    t.text "information"
    t.text "announcement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "birth_date"
    t.string "attd_option"
    t.boolean "check_allergy"
    t.string "allergies"
    t.string "admission_date"
    t.text "information"
    t.integer "user_id"
    t.integer "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attd_mon", default: false
    t.boolean "attd_tue", default: false
    t.boolean "attd_wed", default: false
    t.boolean "attd_thu", default: false
    t.boolean "attd_fri", default: false
    t.integer "timetable_id"
  end

  create_table "timetables", force: :cascade do |t|
    t.string "date"
    t.string "check_in"
    t.string "check_out"
    t.text "report"
    t.boolean "absence"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.text "address"
    t.string "relationship"
    t.string "alternative_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

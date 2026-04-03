# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_03_054116) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "candidate_skills", force: :cascade do |t|
    t.bigint "candidate_id"
    t.datetime "created_at", null: false
    t.string "level"
    t.float "score"
    t.bigint "skill_id"
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_candidate_skills_on_candidate_id"
    t.index ["skill_id"], name: "index_candidate_skills_on_skill_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.text "resume_text"
    t.datetime "updated_at", null: false
  end

  create_table "job_applications", force: :cascade do |t|
    t.jsonb "analysis"
    t.bigint "candidate_id"
    t.datetime "created_at", null: false
    t.bigint "job_id"
    t.integer "rank"
    t.integer "score"
    t.integer "smart_score"
    t.datetime "updated_at", null: false
    t.index ["analysis"], name: "index_job_applications_on_analysis", using: :gin
    t.index ["candidate_id"], name: "index_job_applications_on_candidate_id"
    t.index ["job_id", "candidate_id"], name: "index_job_applications_on_job_id_and_candidate_id", unique: true
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["rank"], name: "index_job_applications_on_rank"
    t.index ["score"], name: "index_job_applications_on_score"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["title"], name: "index_jobs_on_title"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.text "feedback"
    t.string "filename"
    t.integer "score"
    t.datetime "updated_at", null: false
  end

# Could not dump table "skills" because of following StandardError
#   Unknown type 'vector(768)' for column 'embedding'


  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "jobs", "users"
end

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

ActiveRecord::Schema[8.1].define(version: 2026_03_20_065851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

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

end

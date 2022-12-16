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

ActiveRecord::Schema[7.0].define(version: 2022_12_16_032826) do
  create_table "authors", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name"], name: "index_authors_on_first_name"
    t.index ["last_name"], name: "index_authors_on_last_name"
    t.index ["middle_name", "first_name", "last_name"], name: "index_authors_on_middle_name_and_first_name_and_last_name"
    t.index ["middle_name", "last_name", "first_name"], name: "index_authors_on_middle_name_and_last_name_and_first_name"
    t.index ["middle_name"], name: "index_authors_on_middle_name"
  end

  create_table "books", force: :cascade do |t|
    t.integer "publisher_id", null: false
    t.string "isbn13", null: false
    t.string "title", null: false
    t.decimal "list_price", precision: 10, scale: 2, null: false
    t.integer "publication_year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "upper(replace(isbn13,'-',''))", name: "normalized_isbn13_uniq_idx", unique: true
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
    t.index ["title"], name: "index_books_on_title"
    t.check_constraint "length(isbn13) >= 13", name: "isbn13_length_check"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower(name)", name: "index_publishers_on_lower_name", unique: true
  end

  add_foreign_key "books", "publishers"
end

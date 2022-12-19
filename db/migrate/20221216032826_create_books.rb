class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.belongs_to :publisher, null: false, foreign_key: true

      t.string :isbn13, null: false, length: 17
      t.string :title, null: false, presence: true
  
      t.decimal :list_price, null: false, precision: 10, scale: 2
      t.integer :publication_year, null: false

      t.timestamps

      t.check_constraint "length(isbn13) >= 13", name: "isbn13_length_check"
    end

    add_index :books, "upper(replace(isbn13,'-',''))", unique: true, name: "normalized_isbn13_uniq_idx"
    add_index :books, :title
  end
end

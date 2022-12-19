class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :first_name, null: false, index: true
      t.string :last_name, null: false, index: true
      t.string :middle_name, index: true

      t.timestamps

      t.index [:middle_name, :first_name, :last_name]
      t.index [:middle_name, :last_name, :first_name]
    end
  end
end

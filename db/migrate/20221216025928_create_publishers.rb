class CreatePublishers < ActiveRecord::Migration[7.0]
  def change
    create_table :publishers do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :publishers, "lower(name)", unique: true
  end
end

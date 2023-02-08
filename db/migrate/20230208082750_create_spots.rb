class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address
      t.string :feature
      t.text :describe
      t.string :images

      t.timestamps
    end
  end
end

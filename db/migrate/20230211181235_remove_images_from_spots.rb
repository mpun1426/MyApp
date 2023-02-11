class RemoveImagesFromSpots < ActiveRecord::Migration[6.1]
  def change
    remove_column :spots, :images, :json
  end
end

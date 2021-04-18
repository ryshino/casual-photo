class AddStatusToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :status, :integer, default: 0, null: false
  end
end

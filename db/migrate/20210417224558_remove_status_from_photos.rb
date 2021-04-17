class RemoveStatusFromPhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :status, :integer
  end
end

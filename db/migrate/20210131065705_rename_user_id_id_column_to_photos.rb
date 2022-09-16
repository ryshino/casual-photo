class RenameUserIdIdColumnToPhotos < ActiveRecord::Migration[5.2]
  def change
    rename_column :photos, :user_id_id, :user_id
  end
end

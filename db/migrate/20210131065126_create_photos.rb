class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :body
      t.string :image_id

      t.timestamps
    end
  end
end

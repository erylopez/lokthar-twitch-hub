class AddVideoCollectionToAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :video_collection, :jsonb
  end
end

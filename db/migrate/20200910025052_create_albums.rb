class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.jsonb :imgur_response
      t.string :imgur_url
      t.datetime :imgur_sync_at
      t.string :title
      t.boolean :published, default: false

      t.timestamps
    end
  end
end

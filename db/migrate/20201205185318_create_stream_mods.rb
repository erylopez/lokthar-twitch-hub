class CreateStreamMods < ActiveRecord::Migration[6.0]
  def change
    create_table :stream_mods do |t|
      t.references :user, null: false, foreign_key: true
      t.references :streamer, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateTtsItems < ActiveRecord::Migration[6.0]
  def change
    create_table :tts_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :streamer, null: false, foreign_key: true
      t.string :text_to_speach
      t.boolean :pending, default: true
      t.boolean :accepted

      t.timestamps
    end
  end
end

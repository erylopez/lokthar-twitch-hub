class AddTtsCooldownToStreamers < ActiveRecord::Migration[6.0]
  def change
    add_column :streamers, :tts_cooldown, :integer, default: 300
  end
end

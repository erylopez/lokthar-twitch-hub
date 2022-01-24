class CreateStreamRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :stream_rewards do |t|
      t.references :streamer, null: false, foreign_key: true
      t.string :uid
      t.string :image
      t.string :background_color
      t.boolean :is_enabled, default: true
      t.integer :cost, default: 5000
      t.string :title
      t.string :prompt
      t.boolean :is_user_input_required, default: true
      t.boolean :max_per_stream_enabled, default: false
      t.integer :max_per_stream
      t.boolean :max_per_user_per_stream_enabled, default: false
      t.integer :max_per_user_per_stream
      t.boolean :global_cooldown_enabled, default: false
      t.integer :global_cooldown_seconds
      t.boolean :is_paused, default: false
      t.boolean :is_in_stock, default: true
      t.string :default_image_1x
      t.string :default_image_2x
      t.string :default_image_3x
      t.boolean :should_redemptions_skip_request_queue, default: false
      t.string :cooldown_expires_at

      t.timestamps
    end
  end
end

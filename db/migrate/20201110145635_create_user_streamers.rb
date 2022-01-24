class CreateUserStreamers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_streamers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :streamer, null: false, foreign_key: true
      t.datetime :follow_date
      t.jsonb :subscription_data
      t.datetime :subscription_date

      t.timestamps
    end
  end
end

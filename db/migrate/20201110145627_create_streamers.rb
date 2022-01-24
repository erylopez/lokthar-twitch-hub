class CreateStreamers < ActiveRecord::Migration[6.0]
  def change
    create_table :streamers do |t|
      t.string :uid
      t.string :channel_name
      t.string :avatar_url
      t.string :access_token
      t.string :refresh_token

      t.timestamps
    end
  end
end

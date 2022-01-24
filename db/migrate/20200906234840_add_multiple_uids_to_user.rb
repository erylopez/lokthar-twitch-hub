class AddMultipleUidsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :google_uid, :string
    add_column :users, :twitch_uid, :string
    add_column :users, :discord_uid, :string
    add_column :users, :facebook_uid, :string
  end
end

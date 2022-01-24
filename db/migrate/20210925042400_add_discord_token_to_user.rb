class AddDiscordTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :discord_token, :string
    add_column :users, :discord_refresh_token, :string
  end
end

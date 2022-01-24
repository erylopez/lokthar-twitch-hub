class AddDiscordTagToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :discord_tag, :string
  end
end

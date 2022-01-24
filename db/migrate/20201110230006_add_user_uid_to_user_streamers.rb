class AddUserUidToUserStreamers < ActiveRecord::Migration[6.0]
  def change
    add_column :user_streamers, :user_uid, :string
  end
end

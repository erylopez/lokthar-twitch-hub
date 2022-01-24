class AddIsFollowingToUserStreamers < ActiveRecord::Migration[6.0]
  def change
    add_column :user_streamers, :is_following, :boolean, default: false
  end
end

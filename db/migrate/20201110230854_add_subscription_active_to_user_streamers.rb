class AddSubscriptionActiveToUserStreamers < ActiveRecord::Migration[6.0]
  def change
    add_column :user_streamers, :subscription_active, :boolean, default: false
  end
end

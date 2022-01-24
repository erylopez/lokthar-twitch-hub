class AddDailyLimitToStreamers < ActiveRecord::Migration[6.0]
  def change
    add_column :streamers, :daily_limit, :integer, default: 15
  end
end

# This model associates users with streamers and stores its twitch relationship data.
#
# Schema:
# t.datetime "follow_date"
# t.jsonb "subscription_data"
# t.datetime "subscription_date"
# t.boolean "subscription_active", default: false

class UserStreamer < ApplicationRecord
  belongs_to :user
  belongs_to :streamer

  scope :subs, -> {where(subscription_active: true)}
end

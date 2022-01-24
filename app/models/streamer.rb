class Streamer < ApplicationRecord
  has_many :user_streamers
  has_many :tts_items
  has_many :stream_mods
  has_many :stream_rewards
  has_many :quick_votes
  has_many :quick_vote_topics

  def user_record
    User.find_by_twitch_uid(uid)
  end

  def last_topic
    quick_vote_topics.active&.last
  end
end

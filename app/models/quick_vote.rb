class QuickVote < ApplicationRecord
  belongs_to :streamer
  belongs_to :user
end

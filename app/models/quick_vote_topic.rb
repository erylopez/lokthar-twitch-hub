class QuickVoteTopic < ApplicationRecord
  belongs_to :streamer

  scope :active, ->  {where(active: true)}
  scope :closed, -> {where(active: false)}
end

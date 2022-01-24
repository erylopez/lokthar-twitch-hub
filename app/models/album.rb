class Album < ApplicationRecord
  VIDEO_HOSTS = ["https://www.youtube.com/watch?v=", "https://youtu.be/"]

  scope :ordered, -> { order(:id) }
  scope :published, -> { where(published: true) }

  validates :title, :imgur_url, presence: true

  before_create :parse_imgur

  def parse_imgur
    imgur_id = self.imgur_url.split("gallery/").last
    response = OauthProviders::Imgur.images_from(album_id: imgur_id)

    self.imgur_sync_at = Time.now
    self.imgur_response = response
  end

  def videos
    video_collection.split(",").map do |video|
      next unless VIDEO_HOSTS.any? {|w| video.include?(w)}
      video.split("&").first
    end.compact
  end
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitch discord]

  has_many :user_streamers
  has_many :streamers, through: :user_streamers
  has_many :tts_items

  scope :birthday_current_month, -> { where(birth_month: Time.zone.now.month).order(:birth_day) }
  scope :birthday_next_month, -> { where(birth_month: 1.month.from_now.month).order(:birth_day) }

  def onboarding_ongoing?
    birth_day.blank? || birth_month.blank? || country.blank?
  end

  def streamer_record
    Streamer.find_by_uid(twitch_uid)
  end
end

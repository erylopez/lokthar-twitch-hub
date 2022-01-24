class TtsItem < ApplicationRecord
  belongs_to :user
  belongs_to :streamer

  validate :ten_minutes_cooldown

  scope :pending, -> { where(pending: true).order(created_at: :asc) }
  scope :accepted, -> { where(accepted: true).order(created_at: :desc) }
  scope :rejected, -> { where(accepted: false).order(created_at: :desc) }

  scope :chistes, -> { where(category: 'chistes') }

  def ten_minutes_cooldown
    last_message = TtsItem.where(user: user, streamer: streamer).order(created_at: :asc).last

    if last_message && (last_message.created_at + streamer.tts_cooldown.seconds > DateTime.current)
      minutes = (streamer.tts_cooldown / 60)
      errors.add(:base, "Debes esperar #{minutes} minutos entre cada mensaje para evitar spam.")
    end
  end
end

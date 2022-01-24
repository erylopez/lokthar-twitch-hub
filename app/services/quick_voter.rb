class QuickVoter
  attr_accessor :streamer

  def initialize(streamer_uid:, user_uid:, username:)
    @streamer = Streamer.find_by_uid(streamer_uid)

    @current_user = User.where(twitch_uid: user_uid).first_or_create do |user|
      user.email    = "fake_#{SecureRandom.hex}_username@email.com"
      user.password = Devise.friendly_token[0, 20]
      user.name     = username
    end

    @quick_vote = @streamer.quick_votes.where(user: @current_user).first_or_create(value: 0)
  end

  def add
    @quick_vote.update(value: 1)
  end

  def substract
    @quick_vote.update(value: -1)
  end

  def counter
    @streamer.quick_votes.pluck(:value).reduce(&:+)
  end
end

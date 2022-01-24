module TtsHelper
  def get_daily_limit_for(user:, streamer:)
    user_streamer = streamer.user_streamers.where(user: user).try(:first)

    if user_streamer
      if user_streamer.subscription_active?
        return 9999
      else
        return streamer.daily_limit - user.tts_items.where('created_at > ?', (Date.current - 1.day)).count
      end
    else
      -5
    end
  end

end
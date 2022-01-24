class TtsWidgetChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tts_widget_channel_#{params[:streamer]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def play
  end

  def mute
  end

  def unmute
  end

  def refresh
  end
end

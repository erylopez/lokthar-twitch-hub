class Streamers::TtsActionsController < Streamers::BaseController
  before_action :check_access!

  def play
    ActionCable.server.broadcast("tts_widget_channel_#{params[:id]}", action: 'play', filename: params[:filename])
  end

  def mute
    ActionCable.server.broadcast("tts_widget_channel_#{params[:id]}", action: 'mute')
  end

  def unmute
    ActionCable.server.broadcast("tts_widget_channel_#{params[:id]}", action: 'unmute')
  end

  def stop
    ActionCable.server.broadcast("tts_widget_channel_#{params[:id]}", action: 'stop')
  end

  def refresh
    ActionCable.server.broadcast("tts_widget_channel_#{params[:id]}", action: 'refresh')
  end
end
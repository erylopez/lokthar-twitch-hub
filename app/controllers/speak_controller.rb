class SpeakController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index; end

  def create
    tts_item = TtsItem.find(params[:id])
    Tts.new.speak(text: tts_item.text_to_speach, filename: tts_item.streamer.channel_name)
    tts_item.update(pending: false, accepted: true)
    render json: {filename: tts_item.streamer.channel_name}
  end

  def reject
    tts_item = TtsItem.find(params[:id])
    tts_item.update(pending: false, accepted: false)
    render json: {message: 'tts rejected'}
  end
end

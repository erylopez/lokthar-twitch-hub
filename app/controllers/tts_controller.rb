class TtsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :get_streamer

  def show
    if @streamer
      follow_resp = OauthProviders::Twitch.get_follower_date(user: current_user, streamer: @streamer)

      if follow_resp["error"].present?
        session[:user_return_to] = tt_path(id: @streamer.channel_name)
        redirect_to user_twitch_omniauth_authorize_path
      elsif current_user.twitch_uid == @streamer.uid
        @tts_item = TtsItem.new(streamer: @streamer, user: current_user)
      elsif follow_resp["total"].zero?
        @tts_item = TtsItem.new
        render :follow_cta
      else
        user_streamer = UserStreamer.where(user: current_user, streamer: @streamer).first_or_create
        follow_date = Date.parse(follow_resp["data"][0]["followed_at"])
        user_streamer.update(follow_date: follow_date)
        
        @tts_item = TtsItem.new(streamer: @streamer, user: current_user)
      end
    else
      redirect_to root_path, alert: "El canal #{params[:id]} aun no tiene soporte en nuestro sistema de TTS."
    end
  end

  def create
    @tts_item = TtsItem.new(streamer: @streamer, user: current_user, text_to_speach: tts_item_params[:text_to_speach])
    if @tts_item.save
      redirect_to tt_path(id: @streamer.channel_name), notice: "Se envio el mensaje!"
    else
      render :show
    end
  end

  protected

  def get_streamer
    @streamer = Streamer.find_by_channel_name(params[:id])
    last_message = TtsItem.where(user: current_user, streamer: @streamer).order(created_at: :asc).last

    @timer_ends_at = last_message ? last_message.created_at + 10.minutes : 30.minutes.ago
    @daily_limit = helpers.get_daily_limit_for(user: current_user, streamer: @streamer)
  end

  def tts_item_params
    params.require(:tts_item).permit(:text_to_speach)
  end
end
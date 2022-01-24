class Streamers::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  protected

  def check_access!
    @streamer = Streamer.find_by_channel_name(params[:id])

    unless has_access?(user: current_user, streamer: @streamer)
      redirect_to root_path, alert: 'No tienes permiso para acceder a esta pagina' and return
    end
  end

  def has_access?(user:, streamer:)
    user.streamer_record == streamer || streamer.stream_mods.where(user: current_user).any?
  end

end
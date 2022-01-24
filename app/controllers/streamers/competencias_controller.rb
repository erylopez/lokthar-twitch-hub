class Streamers::CompetenciasController < Streamers::BaseController
  before_action :authenticate_user!

  def show
    @streamer = Streamer.find_by_channel_name(params[:id])

    unless has_access?(user: current_user, streamer: @streamer)
      redirect_to root_path, alert: 'No tienes permiso para acceder a esta pagina' and return
    end

    @items = TtsItem.where(streamer: @streamer, category: (params[:category] || 'chiste'))
  end

  def destroy
    @tts_item = TtsItem.find(params[:id])
    streamer = @tts_item.streamer.channel_name
    @tts_item.destroy

    redirect_to streamers_competencia_path(id: streamer)
  end
end

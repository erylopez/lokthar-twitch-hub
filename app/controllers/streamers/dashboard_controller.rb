class Streamers::DashboardController < Streamers::BaseController
  before_action :authenticate_user!

  def index
    @streamer = Streamer.find_by_channel_name(params[:id])

    unless has_access?(user: current_user, streamer: @streamer)
      redirect_to root_path, alert: 'No tienes permiso para acceder a esta pagina' and return
    end
  end
end

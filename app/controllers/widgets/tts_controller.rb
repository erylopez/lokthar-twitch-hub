class Widgets::TtsController < Widgets::BaseController
  def show
    @streamer = Streamer.find_by_channel_name(params[:id])
  end
end

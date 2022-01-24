class Widgets::QuickVotesController < Widgets::BaseController
  def show
    @streamer = Streamer.find_by_channel_name(params[:id])
    @counter = @streamer.quick_votes.pluck(:value).reduce(&:+)
  end
end

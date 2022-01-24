class Streamers::QuickVotesController < Streamers::BaseController
  before_action :authenticate_user!

  def show
    @streamer = Streamer.find_by_channel_name(params[:id])

    unless has_access?(user: current_user, streamer: @streamer)
      redirect_to root_path, alert: 'No tienes permiso para acceder a esta pagina' and return
    end

    @quick_vote_topie = QuickVoteTopic.new
  end

  def create
    @streamer = Streamer.find_by_channel_name(params[:streamer])
    @streamer.quick_vote_topics.update_all(active: false)
    @streamer.quick_vote_topics.create(topic: params[:topic], active: true)

    redirect_to streamers_quick_vote_path(id: params[:streamer])
  end

  def update
    @quick_vote_topic = QuickVoteTopic.find(params[:id])

    if params[:requested_action] == 'close'
      @quick_vote_topic.update(active: false)
      @quick_vote_topic.streamer.quick_votes.destroy_all
      ActionCable.server.broadcast("quick_vote_counter_channel_#{@quick_vote_topic.streamer.channel_name}", counter: " ")
    end

    redirect_to streamers_quick_vote_path(id: @quick_vote_topic.streamer.channel_name), notice: "Se cerro el quick vote #{@quick_vote_topic.topic}"
  end
end

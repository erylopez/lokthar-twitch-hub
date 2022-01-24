class Api::QuickVotesController < Api::BaseController
  def index
    service = QuickVoter.new(streamer_uid: params[:from_channel], user_uid: params[:from_uid], username: params[:user_name])

    unless service.streamer.last_topic.present?
      render plain: " " and return
    end

    if params[:operator] == "add"
      service.add
    elsif params[:operator] = "substract"
      service.substract
    end

    service.streamer.last_topic.update(last_counter: service.counter)
    ActionCable.server.broadcast("quick_vote_counter_channel_#{service.streamer.channel_name}", counter: service.counter)

    render plain: " " and return
  end
end

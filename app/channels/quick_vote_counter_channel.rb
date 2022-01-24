class QuickVoteCounterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "quick_vote_counter_channel_#{params[:streamer]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

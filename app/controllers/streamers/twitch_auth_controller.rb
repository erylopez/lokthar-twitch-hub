class Streamers::TwitchAuthController < Streamers::BaseController
  before_action :authenticate_user!

  def index; end

  def flow
    @access_token = params[:code]

    res = HTTParty.post("https://id.twitch.tv/oauth2/token"+
      "?client_id=#{ENV['TWITCH_CLIENT_ID']}" +
      "&client_secret=#{ENV['TWITCH_CLIENT_SECRET']}" +
      "&code=#{@access_token}" +
      "&grant_type=authorization_code" +
      "&redirect_uri=#{flow_streamers_twitch_auth_index_url}"
    )

    user_response = HTTParty.get("https://api.twitch.tv/helix/users", headers: {
      'Authorization' => "Bearer #{res["access_token"]}",
      'Accept' => 'application/vnd.twitchtv.v5+json',
      'Client-ID' => ENV['TWITCH_CLIENT_ID']
    })

    user_info = user_response.try(:[], "data").try(:first)

    unless user_info["id"].present?
      render json: {msg: 'error'} and return
    end

    streamer = Streamer.where(uid: user_info["id"]).first_or_create do |strmr|
      strmr.avatar_url = user_info["profile_image_url"]
      strmr.channel_name = user_info["login"]
    end

    streamer.update(access_token: res["access_token"], refresh_token: res["refresh_token"])

    if res["access_token"]
      response = HTTParty.get("https://api.twitch.tv/helix/subscriptions?broadcaster_id=#{streamer.uid}", headers: {
        'Authorization' => "Bearer #{res["access_token"]}",
        'Accept' => 'application/vnd.twitchtv.v5+json',
        'Client-ID' => ENV['TWITCH_CLIENT_ID']
      })

      @subs = response["data"]

      until response["pagination"].empty?
        cursor = response["pagination"]["cursor"]

        response = HTTParty.get("https://api.twitch.tv/helix/subscriptions?broadcaster_id=#{streamer.uid}&after=#{cursor}", headers: {
          'Authorization' => "Bearer #{res["access_token"]}",
          'Accept' => 'application/vnd.twitchtv.v5+json',
          'Client-ID' => ENV['TWITCH_CLIENT_ID']
        })

        @subs = @subs + response["data"]
      end

      #Only way to check for acive subscriptions it to log in daily, without hooks
      UserStreamer.where(streamer_id: streamer.id).update_all(subscription_active: false)

      @subs.each do |subscription|
        next unless subscription.any?

        sub_user = User.where(twitch_uid: subscription["user_id"]).first_or_create do |user|
          user.email       = "fake_#{SecureRandom.hex}@email.com"
          user.password    = Devise.friendly_token[0, 20]
          user.name        = subscription["user_name"]
        end

        user_streamer = UserStreamer.where(user_id: sub_user.id, streamer_id: streamer.id).first_or_create do |us_obj|
          us_obj.user_uid = subscription["user_id"]
        end

        user_streamer.update(subscription_active: true, subscription_data: subscription)
      end

      update_rewards(token: res["access_token"], streamer: streamer)

      redirect_to streamers_dashboard_index_path(id: streamer.channel_name), notice: "Bienvenido #{streamer.channel_name}!" and return
    end

    render json: {msg: 'ok'}
  end

  protected

  def update_rewards(token:, streamer:)
    rewards_res = HTTParty.get("https://api.twitch.tv/helix/channel_points/custom_rewards?broadcaster_id=#{streamer.uid}", headers: {
      'Authorization' => "Bearer #{token}",
      'Accept' => 'application/vnd.twitchtv.v5+json',
      'Client-ID' => ENV['TWITCH_CLIENT_ID']
    })

    return false unless rewards_res["data"].present?

    rewards_res["data"].each do |reward|
      StreamReward.where(streamer: streamer, uid: reward['id']).first_or_create(
        image: reward['image'],
        background_color: reward['background_color'],
        is_enabled: reward['is_enabled'],
        cost: reward['cost'],
        title: reward['title'],
        prompt: reward['prompt'],
        is_user_input_required: reward['is_user_input_required'],
        max_per_stream_enabled: reward.try(:[], "max_per_stream_setting").try(:[], "is_enabled"),
        max_per_stream: reward.try(:[], "max_per_stream_setting").try(:[], "max_per_stream"),
        max_per_user_per_stream_enabled: reward.try(:[], "max_per_user_per_stream_setting").try(:[], "is_enabled"),
        max_per_user_per_stream: reward.try(:[], "max_per_user_per_stream_setting").try(:[], "max_per_user_per_stream"),
        global_cooldown_enabled: reward.try(:[], "global_cooldown_setting").try(:[], "is_enabled"),
        global_cooldown_seconds: reward.try(:[], "global_cooldown_setting").try(:[], "global_cooldown_seconds"),
        is_paused: reward['is_paused'],
        is_in_stock: reward['is_in_stock'],
        default_image_1x: reward.try(:[], "default_image").try(:[], "url_1x"),
        default_image_2x: reward.try(:[], "default_image").try(:[], "url_2x"),
        default_image_3x: reward.try(:[], "default_image").try(:[], "url_3x"),
        should_redemptions_skip_request_queue: reward['should_redemptions_skip_request_queue'],
        cooldown_expires_at: reward['cooldown_expires_at']
      )
    end
  end
end
class Api::TtsController < Api::BaseController
  def index
    text          = params[:query]
    user_uid      = params[:from_uid]
    username      = params[:user_name]
    streamer_uid  = params[:from_channel]
    level         = params[:user_level]
    category      = params[:category]

    streamer = Streamer.find_by_uid(streamer_uid)

    unless streamer
      render plain: "Streamer no registrado en Lokthar." and return
    end

    current_user = User.where(twitch_uid: user_uid).first_or_create do |user|
      user.email    = "fake_#{SecureRandom.hex}_username@email.com"
      user.password = Devise.friendly_token[0, 20]
      user.name     = username
    end

    if level.in?(['owner'])
      follow_resp = {"total" => 1,"data" => [{"followed_at" => 1.year.ago.to_s }],"pagination" =>{}}
    else
      follow_resp = OauthProviders::Twitch.get_follower_date(user: current_user, streamer: streamer)
    end

    if follow_resp['error'].present?
      render plain: "El streamer necesita volver a loguear en Lokthar" and return
    elsif follow_resp["total"].zero?
      render plain: "Comando solo disponible para followers y subs" and return
    end

    followed_at = follow_resp.try(:[], "data").try(:first).try(:[], "followed_at")

    user_streamer = UserStreamer.where(user_id: user_uid, streamer_id: streamer_uid).first_or_create do |us_obj|
      if level == "subscriber"
        us_obj.subscription_active = true
        us_obj.subscription_data = {user_name: username, plan_name: 'from Chat command'}
      end

      us_obj.follow_date = Date.parse(followed_at) if followed_at.is_a?(String)
    end

    tts_item = TtsItem.new(streamer: streamer, user: current_user, text_to_speach: text, category: category)

    unless tts_item.save
      render plain: tts_item.errors.full_messages.first and return
    end

    Tts.new.speak(text: tts_item.text_to_speach, filename: tts_item.streamer.channel_name)
    tts_item.update(pending: false, accepted: true)
    filename = "https://lokthar.com/#{tts_item.streamer.channel_name}.mp3?cache=#{SecureRandom.hex}"
    ActionCable.server.broadcast("tts_widget_channel_#{streamer.channel_name}", action: 'play', filename: filename)

    limit =  helpers.get_daily_limit_for(user: current_user, streamer: streamer)

    if limit > streamer.daily_limit
      render plain: " " and return
    elsif limit == -5
      render plain: "Intenta de nuevo o prueba mandar el mensaje desde https://lokthar.com/tts/#{streamer.channel_name}"
    elsif limit < 1
      render plain: "Superaste el limite diario de mensajes. Obten mensajes ilimitados diarios suscribiendote a #{streamer.channel_name}" and return
    else
      render plain: "Aun puedes enviar #{pluralize(@daily_limit, 'mensaje')} hoy. Obten mensajes ilimitados diarios suscribiendote a #{streamer.channel_name}" and return
    end
  end

  def chiste
    text          = params[:query]
    user_uid      = params[:from_uid]
    username      = params[:user_name]
    streamer_uid  = params[:from_channel]
    category      = params[:category]

    streamer = Streamer.find_by_uid(streamer_uid)

    current_user = User.where(twitch_uid: user_uid).first_or_create do |user|
      user.email    = "fake_#{SecureRandom.hex}_username@email.com"
      user.password = Devise.friendly_token[0, 20]
      user.name     = username
    end

    tts_item = TtsItem.where(streamer: streamer, user: current_user, category: 'chiste').first_or_create(text_to_speach: text)
    #http://localhost:3000/api/tts/chiste?query=test&from_uid=36476430&user_name=ksixx&from_channel=36476430&category=chiste
    render plain: " " and return
  end
end
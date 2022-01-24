class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitch
    @user = OauthProviders::Twitch.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      # sign_in_and_redirect @user, event: :authentication
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Twitch") if is_navigational_format?

      if @user.onboarding_ongoing?
        redirect_url = session[:user_return_to] || onboarding_url
        redirect_to redirect_url, notice: "Sesion iniciada con Twitch!"
      else
        redirect_to root_path, notice: "Sesion iniciada con Twitch!"
      end
    else
      session["devise.twitch_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = OauthProviders::Google.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end

  def discord
    auth = request.env["omniauth.auth"]
    
    user = User.where(discord_uid: auth.uid).first_or_create do |user|
      user.email       = auth.info.email || "discord_#{auth.uid}@lokthar.com"
      user.password    = Devise.friendly_token[0, 20]
      user.discord_tag = "#{auth.extra.raw_info.username}##{auth.extra.raw_info.discriminator}"
      user.points      = 1000
      user.name        = auth.info.name
      user.avatar_url  = auth.info.image

      user.discord_token         = auth.credentials.token
      user.discord_refresh_token = auth.credentials.refresh_token
    end

    # res = HTTParty.get('http://localhost:3000/api/auth/csrf')
    # csrf_token = res.parsed_response["csrfToken"]

    # HTTParty.post('http://localhost:3000/api/auth/signin/', body: {csrfToken: csrf_token}, headers: {
    #   "Content-Type": "application/x-www-form-urlencoded",
    # })

    # render json: request.env["omniauth.auth"]
    redirect_to "http://localhost:3000/authorization?uid=#{user.discord_uid}"
    # if OauthProviders::Discord.from_omniauth(auth: request.env["omniauth.auth"], user: current_user)
    #   if current_user.onboarding_ongoing?
    #     redirect_to onboarding_url, notice: "Linkeaste Discord a tu cuenta!"
    #   else
    #     redirect_to cuenta_path, notice: "Linkeaste Discord a tu cuenta!"
    #   end
    # else
    #   session["devise.discord_data"] = request.env["omniauth.auth"].except(:extra)
    #   redirect_to new_user_registration_url
    # end
  end

  def facebook
    @user = OauthProviders::Facebook.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def imgur
    puts params
    puts request.env
    render json: {msg: 'not ready'}
  end

  def failure
    redirect_to root_path
  end
end

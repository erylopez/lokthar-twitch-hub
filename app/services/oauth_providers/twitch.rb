require 'httparty'

module OauthProviders
  class Twitch
    def self.from_omniauth(auth)
      current_user = User.where(twitch_uid: auth.uid).first_or_create do |user|
        user.email       = auth.info.email
        user.password    = Devise.friendly_token[0, 20]
        user.name        = auth.info.nickname
        user.avatar_url  = auth.info.image
      end

      current_user.update(
        token: auth&.credentials&.token,
        refresh_token: auth&.credentials&.refresh_token,
        token_date: auth&.credentials&.expires_at
      )

      return current_user
    end

    def self.get_follower_date(user:, streamer:)
      response = HTTParty.get("https://api.twitch.tv/helix/users/follows?from_id=#{user.twitch_uid}&to_id=#{streamer.uid}", {
        headers: {"Authorization" => "Bearer #{user.token}", "Client-Id" => ENV["TWITCH_CLIENT_ID"]}
      })

      puts "Follower Response----------"
      puts response

      if response["error"] == "Unauthorized" #{"error":"Unauthorized","status":401,"message":"Invalid OAuth token"}
        response_2 = HTTParty.get("https://api.twitch.tv/helix/users/follows?from_id=#{user.twitch_uid}&to_id=#{streamer.uid}", {
          headers: {"Authorization" => "Bearer #{streamer.access_token}", "Client-Id" => ENV["TWITCH_CLIENT_ID"]}
        })

        return response_2
      else
        return response
      end
    end
  end
end

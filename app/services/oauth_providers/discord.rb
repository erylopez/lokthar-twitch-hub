module OauthProviders
  class Discord
    def self.from_omniauth(auth:, user:)
      user.update(points: user.points + 1000) unless user.discord_uid.present?
      user.update(discord_uid: auth.uid, discord_tag: "#{auth.extra.raw_info.username}##{auth.extra.raw_info.discriminator}")
    end
  end
end
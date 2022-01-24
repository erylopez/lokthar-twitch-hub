module OauthProviders
  class Facebook
    def self.from_omniauth(auth)
      User.where(facebook_uid: auth.uid).first_or_create do |user|
        user.email      = auth.info.email
        user.password   = Devise.friendly_token[0, 20]
        user.name       = auth.info.name
        user.avatar_url = auth.info.image
      end
    end
  end
end
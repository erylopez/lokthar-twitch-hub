module OauthProviders
  class Google
    def self.from_omniauth(auth)
      User.where(google_uid: auth.uid).first_or_create do |user|
        user.email      = auth.info.email
        user.password   = Devise.friendly_token[0, 20]
        user.name       = auth.info.name
        user.avatar_url = auth.info.picture
      end
    end
  end
end
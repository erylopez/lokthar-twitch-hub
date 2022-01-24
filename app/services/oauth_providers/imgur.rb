require "uri"
require "net/http"

module OauthProviders
  class Imgur
    def initialize
      @client_id = ENV['IMGUR_CLIENT_ID']
      @secret    = ENV['IMGUR_CLIENT_SECRET']
    end

    def self.authorize
      url = URI.parse("https://api.imgur.com/oauth2/authorize?client_id=#{ENV['IMGUR_CLIENT_ID']}&response_type=REQUESTED_RESPONSE_TYPE&state=APPLICATION_STATE")
      req = Net::HTTP::Get.new(url.to_s)
      req['Authorization'] = "Client-ID #{ENV['IMGUR_CLIENT_ID']}"
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      puts res.body
    end

    def self.get_album(album_id:)
      url = URI("https://api.imgur.com/3/album/#{album_id}")

      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["Authorization"] = "Client-ID #{ENV['IMGUR_CLIENT_ID']}"
      form_data = []
      request.set_form form_data, 'multipart/form-data'
      response = https.request(request)
      return JSON.parse(response.body)
    end

    def self.images_from(album_id:)
      begin
        get_album(album_id: album_id).try(:[], 'data').try(:[], 'images').map{|images| images.try(:[], "link")}
      rescue JSON::ParserError => e
        puts e
        return []
      end
    end
  end
end
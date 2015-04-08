require 'httparty'

class Idol
  include HTTParty

  base_uri 'https://api.idolondemand.com/1/api/sync'

  def self.extract_text url
    get '/extracttext/v1', query: {
      'apikey' => CF::App::Credentials.find_by_service_name('extracttext')['apikey'],
      'url'    => url
    }
  end

end

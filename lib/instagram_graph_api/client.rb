require 'koala'

module InstagramGraphApi
  class Client < Koala::Facebook::API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    Koala.config.api_version = "v20.0"

    include InstagramGraphApi::Client::Users
    include InstagramGraphApi::Client::Media
    include InstagramGraphApi::Client::Discovery
  end
end
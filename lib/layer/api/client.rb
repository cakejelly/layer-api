require "layer/api/client/conversations"
require "layer/api/client/announcements"
require "layer/api/client/users"
require "layer/api/client/identity_token"

module Layer
  module Api
    class Client
      include Layer::Api::Connection
      include Layer::Api::Configuration

      include Layer::Api::Conversations
      include Layer::Api::Announcements
      include Layer::Api::Users

      attr_accessor :api_token, :app_id

      def initialize(options = {})
        @api_token = options[:api_token] || ENV['LAYER_API_TOKEN']
        @app_id = options[:app_id] || ENV['LAYER_APP_ID']
      end
    end
  end
end

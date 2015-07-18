require "layer/api/client/conversations"
require "layer/api/client/announcements"
require "layer/api/client/users"

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
        @api_token = options[:api_token]
        @app_id = options[:app_id]
      end
    end
  end
end

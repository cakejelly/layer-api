require "layer/api/client/conversations"
require "layer/api/client/announcements"

module Layer
  module Api
    class Client
      include Layer::Api::Configuration

      include Layer::Api::Conversations
      include Layer::Api::Announcements

      attr_accessor :api_token, :app_id

      def initialize(options = {})
        @api_token = options[:api_token]
        @app_id = options[:app_id]
      end
    end
  end
end

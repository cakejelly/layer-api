require "layer/api/client/conversations"

module Layer
  module Api
    class Client
      include Layer::Api::Configuration

      include Layer::Api::Conversations

      attr_accessor :api_token, :app_id

      def initialize(options = {})
        @api_token = options[:api_token]
        @app_id = options[:app_id]
      end
    end
  end
end
